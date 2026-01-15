// lib/features/agent_home/cubit/add_apartment_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved/features/agent_home/repository/agent_repository.dart';
import 'add_apartment_state.dart';

class AddApartmentCubit extends Cubit<AddApartmentState> {
  final AgentRepository _agentRepository;

  AddApartmentCubit(this._agentRepository) : super(const AddApartmentState.initial());

  Future<void> submitApartment({
    required String title,
    required String description,
    required String price,
    required int rooms,
    required String address,
    required int cityId,
    required int areaId,
    required List<int> amenities,
    required List<XFile> images,
  }) async {
    try {
      emit(const AddApartmentState.loading());
      final newApartment = await _agentRepository.addApartment(
        title: title,
        description: description,
        price: price,
        rooms: rooms,
        address: address,
        cityId: cityId,
        areaId: areaId,
        amenities: amenities,
        images: images,
      );
      emit(AddApartmentState.success(newApartment));
    } catch (e) {
      emit(AddApartmentState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
