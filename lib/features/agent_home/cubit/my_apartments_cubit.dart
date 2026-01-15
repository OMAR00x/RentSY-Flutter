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
      // After a successful deletion, refresh the list to reflect the change.
      await fetchMyApartments();
    } catch (e) {
      // If deletion fails, we can show an error.
      // For now, the list will just not update. You could add more complex error handling here.
      // For example, by emitting a new state that the UI can listen for to show a SnackBar.
    }
  }
}
