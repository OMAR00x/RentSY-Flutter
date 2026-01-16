import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/amenity_model.dart';
import 'package:saved/core/domain/models/area_model.dart';
import 'package:saved/core/domain/models/city_model.dart';
import 'package:saved/core/domain/models/filter_params.dart';
import 'package:saved/features/agent_home/repository/agent_repository.dart'; // يستخدم لجلب المدن والميزات

part 'filter_cubit.freezed.dart'; // ستحتاج إلى تشغيل `flutter pub run build_runner build` لتوليد هذا الملف

@freezed
abstract class FilterState with _$FilterState {
  const factory FilterState.initial() = _Initial;
  const factory FilterState.loading() = _Loading;
  const factory FilterState.success({
    required List<CityModel> cities,
    required List<AreaModel> areas, // المناطق للمدينة المختارة
    required List<AmenityModel> allAmenities,
    required FilterParams currentFilterParams, // يحتوي على الفلاتر المختارة
  }) = _Success;
  const factory FilterState.error(String message) = _Error;
}

class FilterCubit extends Cubit<FilterState> {
  final AgentRepository _agentRepository;
  FilterParams _initialParams = FilterParams();

  FilterCubit(this._agentRepository) : super(const FilterState.initial());

  void setInitialParams(FilterParams params) {
    _initialParams = params;
  }

  Future<void> loadFilterOptions() async {
    if (state is _Loading) return; // منع التحميل المتكرر
    
    emit(const FilterState.loading());
    try {
      final cities = await _agentRepository.getCities();
      final allAmenities = await _agentRepository.getAmenities();

      List<AreaModel> areas = [];
      if (_initialParams.cityId != null) {
        try {
          areas = await _agentRepository.getAreasForCity(_initialParams.cityId!);
        } catch (e) {
          areas = [];
        }
      }

      emit(FilterState.success(
        cities: cities,
        areas: areas,
        allAmenities: allAmenities,
        currentFilterParams: _initialParams.copyWith(),
      ));
    } catch (e) {
      emit(FilterState.error('Failed to load filter options. Please try again.'));
    }
  }

  // عند اختيار مدينة جديدة
  Future<void> onCitySelected(CityModel? city) async {
    if (state is _Success) {
      final currentState = state as _Success;
      List<AreaModel> areas = [];
      FilterParams updatedParams = currentState.currentFilterParams.copyWith(
        cityId: city?.id,
        areaId: null,
        resetCity: city == null,
        resetArea: true,
      );

      if (city != null) {
        try {
          areas = await _agentRepository.getAreasForCity(city.id);
        } catch (e) {
          areas = [];
        }
      }
      emit(currentState.copyWith(
        areas: areas,
        currentFilterParams: updatedParams,
      ));
    }
  }

  // عند اختيار منطقة جديدة
  void onAreaSelected(AreaModel? area) {
    if (state is _Success) {
      final currentState = state as _Success;
      final updatedParams = currentState.currentFilterParams.copyWith(
        areaId: area?.id,
      );
      emit(currentState.copyWith(currentFilterParams: updatedParams));
    }
  }

  // عند تغيير نطاق السعر
  void onPriceRangeChanged(double min, double max) {
    if (state is _Success) {
      final currentState = state as _Success;
      final updatedParams = currentState.currentFilterParams.copyWith(
        minPrice: min,
        maxPrice: max,
      );
      emit(currentState.copyWith(currentFilterParams: updatedParams));
    }
  }

  // عند اختيار عدد الغرف
  void onRoomsSelected(int? rooms) {
    if (state is _Success) {
      final currentState = state as _Success;
      final updatedParams = currentState.currentFilterParams.copyWith(
        minRooms: rooms,
      );
      emit(currentState.copyWith(currentFilterParams: updatedParams));
    }
  }

  // عند تفعيل/إلغاء تفعيل ميزة (Amenity)
  void onAmenityToggled(AmenityModel amenity, bool isSelected) {
    if (state is _Success) {
      final currentState = state as _Success;
      List<int> currentAmenities = List.from(currentState.currentFilterParams.amenityIds ?? []);
      if (isSelected) {
        if (!currentAmenities.contains(amenity.id)) {
          currentAmenities.add(amenity.id);
        }
      } else {
        currentAmenities.remove(amenity.id);
      }
      final updatedParams = currentState.currentFilterParams.copyWith(
        amenityIds: currentAmenities,
      );
      emit(currentState.copyWith(currentFilterParams: updatedParams));
    }
  }

  void resetFilters() {
    _initialParams = FilterParams();
    loadFilterOptions();
  }

  // getter للحصول على معايير الفلترة المطبقة النهائية
  FilterParams get getAppliedFilterParams {
    if (state is _Success) {
      return (state as _Success).currentFilterParams;
    }
    return FilterParams();
  }
}
