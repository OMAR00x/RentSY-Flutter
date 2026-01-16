import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/core/domain/models/search_history_model.dart';
import 'package:saved/features/renter_home/repository/renter_repository.dart';

class SearchHistoryCubit extends Cubit<List<SearchHistoryModel>> {
  final RenterRepository _repository;

  SearchHistoryCubit(this._repository) : super([]);

  Future<void> loadHistory() async {
    try {
      final history = await _repository.getSearchHistory();
      emit(history);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> deleteHistory(int id) async {
    try {
      await _repository.deleteSearchHistory(id);
      emit(state.where((item) => item.id != id).toList());
    } catch (e) {
      // Handle error silently or emit error state if needed
    }
  }
}
