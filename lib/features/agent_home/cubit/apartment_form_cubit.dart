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

  
  Future<void> fetchAreasForCity(int cityId) async {
    
    await state.maybeWhen(
      success: (cities, amenities, _, __) async {
        
        emit(ApartmentFormState.success(
          cities: cities,
          amenities: amenities,
          loadingAreas: true, 
          areas: [], 
        ));

        try {
         
          final areas = await _agentRepository.getAreasForCity(cityId);

          
          emit(ApartmentFormState.success(
            cities: cities,
            amenities: amenities,
            areas: areas, 
            loadingAreas: false, 
          ));
        } catch (e) {
         
          emit(ApartmentFormState.success(
            cities: cities,
            amenities: amenities,
            areas: [],
            loadingAreas: false,
          ));
        }
      },
      
      orElse: () async {},
    );
  }
}
