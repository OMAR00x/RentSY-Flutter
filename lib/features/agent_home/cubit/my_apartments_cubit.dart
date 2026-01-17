// lib/features/agent_home/cubit/my_apartments_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/features/agent_home/repository/agent_repository.dart';

import 'my_apartments_state.dart';

class MyApartmentsCubit extends Cubit<MyApartmentsState> {
  final AgentRepository _agentRepository;

  MyApartmentsCubit(this._agentRepository) : super(const MyApartmentsState.initial());

  Future<void> fetchMyApartments() async {
    try {
      emit(const MyApartmentsState.loading());
      final apartments = await _agentRepository.getMyApartments();
      if (apartments.isEmpty) {
        emit(const MyApartmentsState.empty());
      } else {
        emit(MyApartmentsState.success(apartments));
      }
    } catch (e) {
      emit(MyApartmentsState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }
  
  Future<void> deleteApartment(int apartmentId) async {
    try {
      await _agentRepository.deleteApartment(apartmentId);
      await fetchMyApartments();
    } catch (e) {
      //catch error 
    }
  }

  Future<void> searchApartments(String query) async {
    try {
      emit(const MyApartmentsState.loading());
      final apartments = await _agentRepository.getMyApartments();
      final filtered = apartments.where((apt) => 
        apt.title.toLowerCase().contains(query.toLowerCase()) ||
        apt.address.toLowerCase().contains(query.toLowerCase()) ||
        apt.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      if (filtered.isEmpty) {
        emit(const MyApartmentsState.empty());
      } else {
        emit(MyApartmentsState.success(filtered));
      }
    } catch (e) {
      emit(MyApartmentsState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
