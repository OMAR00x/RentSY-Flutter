// lib/features/agent_home/cubit/apartment_form_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/features/agent_home/repository/agent_repository.dart';
import 'apartment_form_state.dart';
import 'package:saved/core/domain/models/city_model.dart';
import 'package:saved/core/domain/models/amenity_model.dart';

class ApartmentFormCubit extends Cubit<ApartmentFormState> {
  final AgentRepository _agentRepository;

  ApartmentFormCubit(this._agentRepository) : super(const ApartmentFormState.initial());

  Future<void> fetchFormData() async {
    emit(const ApartmentFormState.loading());
    try {
      final results = await Future.wait([
        _agentRepository.getAmenities(),
        _agentRepository.getCities(),
      ]);
      final amenities = results[0] as List<AmenityModel>;
      final cities = results[1] as List<CityModel>;
      emit(ApartmentFormState.success(cities: cities, amenities: amenities));
    } catch (e) {
      emit(ApartmentFormState.error('Failed to load cities. Please try again.'));
    }
  }

  // --- ✨ هنا الإصلاح الرئيسي ---
  Future<void> fetchAreasForCity(int cityId) async {
    // استخدم .maybeWhen للوصول إلى الحالة الحالية بأمان
    await state.maybeWhen(
      success: (cities, amenities, _, __) async {
        // 1. نصدر حالة جديدة مع تفعيل مؤشر التحميل للمناطق
        emit(ApartmentFormState.success(
          cities: cities,
          amenities: amenities,
          loadingAreas: true, // تفعيل التحميل
          areas: [], // إفراغ القائمة القديمة
        ));

        try {
          // 2. جلب المناطق من الـ Repository
          final areas = await _agentRepository.getAreasForCity(cityId);

          // 3. نصدر الحالة النهائية مع البيانات الجديدة
          emit(ApartmentFormState.success(
            cities: cities,
            amenities: amenities,
            areas: areas, // إضافة قائمة المناطق الجديدة
            loadingAreas: false, // إيقاف التحميل
          ));
        } catch (e) {
          // 4. في حال حدوث خطأ، نعيد الحالة مع إيقاف التحميل
          emit(ApartmentFormState.success(
            cities: cities,
            amenities: amenities,
            areas: [],
            loadingAreas: false,
          ));
        }
      },
      // orElse: () {} يعني: لا تفعل شيئاً إذا كانت الحالة ليست success
      orElse: () async {},
    );
  }
}
