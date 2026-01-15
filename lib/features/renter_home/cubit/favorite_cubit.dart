
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/features/renter_home/cubit/favorite_state.dart';
import 'package:saved/features/renter_home/repository/renter_repository.dart';
// import 'package:freezed_annotation/freezed_annotation.dart'; // ✨ حذف هذا الاستيراد لأنه غير مستخدم هنا

// ✨ جديد: استيراد collection عشان firstWhereOrNull
import 'package:collection/collection.dart'; // ✨ هذا السطر صح، لأنه بيربط الـ cubit مع الـ state

// ✨ حذف هذا السطر، لأن freezed لا يولد ملفات للـ Cubit نفسه
// part 'favorite_cubit.freezed.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final RenterRepository _renterRepository;

  FavoriteCubit(this._renterRepository) : super(const FavoriteState.initial());

  Future<void> fetchFavoriteApartments() async {
    emit(const FavoriteState.loading());
    try {
      final apartments = await _renterRepository.getFavoriteApartments();
      if (apartments.isEmpty) {
        emit(const FavoriteState.empty());
      } else {
        emit(FavoriteState.loaded(apartments));
      }
    } catch (e) {
      emit(FavoriteState.error(e.toString()));
    }
  }

  Future<void> toggleFavorite(ApartmentModel apartment) async {
    // لو كانت الحالة الحالية Loaded، بنحاول نحدث القائمة مباشرة (optimistic update)
    // هنا بنستخدم when لتغطية كل حالات الـ FavoriteState
    state.whenOrNull(
      loaded: (currentList) {
        final updatedList = currentList.map((item) {
          if (item.id == apartment.id) {
            return item.copyWith(isFavorite: !apartment.isFavorite);
          }
          return item;
        }).toList();
        emit(FavoriteState.loaded(updatedList));
      },
    );

    try {
      final isNowFavorite = await _renterRepository.toggleFavoriteApartment(
        apartment.id,
      );
      // بعد الاستجابة من الـ API، نحدث القائمة النهائية
      state.whenOrNull(
        loaded: (currentList) {
          // لازم نجيب الـ apartment الأصلية (قبل التغيير) إذا كانت موجودة في قائمة المفضلة
          // عشان نقدر نحدثها بشكل صحيح بناءً على الاستجابة
          final originalApartmentInList = currentList.firstWhereOrNull(
            (item) => item.id == apartment.id,
          );

          List<ApartmentModel> finalApartmentsList;

          if (isNowFavorite) {
            // الشقة أصبحت مفضلة
            if (originalApartmentInList == null) {
              // لو ما كانت موجودة في قائمة المفضلة (تم الإضافة من شاشة All Apartments مثلاً)
              // بنضيفها للقائمة
              finalApartmentsList = List.of(currentList)
                ..add(apartment.copyWith(isFavorite: true));
            } else {
              // لو كانت موجودة، بنحدث حالتها
              finalApartmentsList = currentList.map((item) {
                if (item.id == apartment.id) {
                  return item.copyWith(isFavorite: true);
                }
                return item;
              }).toList();
            }
          } else {
            // الشقة لم تعد مفضلة
            // بنشيلها من القائمة
            finalApartmentsList = currentList
                .where((item) => item.id != apartment.id)
                .toList();
          }

          if (finalApartmentsList.isEmpty) {
            emit(const FavoriteState.empty());
          } else {
            emit(FavoriteState.loaded(finalApartmentsList));
          }
        },
        empty: () {
          // لو كانت القائمة فارغة وأضفنا شقة، لازم تصير loaded
          if (isNowFavorite) {
            emit(FavoriteState.loaded([apartment.copyWith(isFavorite: true)]));
          }
        },
      );
    } catch (e) {
      // لو صار خطأ، بنرجع للحالة الأصلية (rollback) لو كنا عملنا optimistic update
      // الأفضل نعمل fetch مرة تانية عشان نجيب الحالة الصحيحة من السيرفر
      fetchFavoriteApartments();
      rethrow;
    }
  }
}
