// lib/features/agent_home/cubit/apartment_form_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/amenity_model.dart';
import 'package:saved/core/domain/models/area_model.dart';
import 'package:saved/core/domain/models/city_model.dart';

part 'apartment_form_state.freezed.dart';

@freezed
class ApartmentFormState with _$ApartmentFormState {
  const factory ApartmentFormState.initial() = _Initial;
  const factory ApartmentFormState.loading() = _Loading;
  const factory ApartmentFormState.success({
    required List<CityModel> cities,
    required List<AmenityModel> amenities,
    @Default([]) List<AreaModel> areas, 
    @Default(false) bool loadingAreas,   
  }) = _Success;
  const factory ApartmentFormState.error(String message) = _Error;
}
