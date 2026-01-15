import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/apartment_model.dart';

part 'all_apartments_state.freezed.dart';

@freezed
abstract class AllApartmentsState with _$AllApartmentsState {
  const factory AllApartmentsState.initial() = _Initial;
  const factory AllApartmentsState.loading() = _Loading;
  const factory AllApartmentsState.success(List<ApartmentModel> apartments) = _Success;
  const factory AllApartmentsState.empty() = _Empty;
  const factory AllApartmentsState.error(String message) = _Error;
}
