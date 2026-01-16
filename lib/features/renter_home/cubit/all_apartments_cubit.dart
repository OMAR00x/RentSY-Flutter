import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/core/domain/models/filter_params.dart';
import 'package:saved/features/renter_home/cubit/all_apartments_state.dart';
import 'package:saved/features/renter_home/repository/renter_repository.dart';

class AllApartmentsCubit extends Cubit<AllApartmentsState> {
  final RenterRepository _renterRepository;

  AllApartmentsCubit(this._renterRepository) : super(const AllApartmentsState.initial());

  Future<void> fetchAllApartments({FilterParams? filterParams}) async {
    emit(const AllApartmentsState.loading());
    try {
      final apartments = await _renterRepository.getAllApartments(filterParams: filterParams);

      if (apartments.isEmpty) {
        emit(const AllApartmentsState.empty());
      } else {
        emit(AllApartmentsState.success(apartments));
      }
    } catch (e) {
      emit(AllApartmentsState.error(e.toString()));
    }
  }

  Future<void> searchApartments(String query) async {
    final filterParams = FilterParams(searchQuery: query);
    await fetchAllApartments(filterParams: filterParams);
  }
}
