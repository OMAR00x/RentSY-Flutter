import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/features/renter_home/cubit/all_apartments_state.dart';
import 'package:saved/features/renter_home/repository/renter_repository.dart';

class AllApartmentsCubit extends Cubit<AllApartmentsState> {
  final RenterRepository _renterRepository;

  AllApartmentsCubit(this._renterRepository) : super(const AllApartmentsState.initial());

  Future<void> fetchAllApartments() async {
    // 1. إصدار حالة التحميل
    emit(const AllApartmentsState.loading());
    try {
      // 2. طلب البيانات من الـ Repository
      final apartments = await _renterRepository.getAllApartments();

      // 3. التحقق من النتيجة وإصدار الحالة المناسبة
      if (apartments.isEmpty) {
        emit(const AllApartmentsState.empty());
      } else {
        emit(AllApartmentsState.success(apartments));
      }
    } catch (e) {
      // 4. في حال حدوث خطأ، يتم إصدار حالة الخطأ
      emit(AllApartmentsState.error(e.toString()));
    }
  }
}
