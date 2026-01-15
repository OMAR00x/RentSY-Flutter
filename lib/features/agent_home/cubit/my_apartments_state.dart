// lib/features/agent_home/cubit/my_apartments_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/apartment_model.dart';


part 'my_apartments_state.freezed.dart';

@freezed
class MyApartmentsState with _$MyApartmentsState {
  const factory MyApartmentsState.initial() = _Initial;
  const factory MyApartmentsState.loading() = _Loading;
  const factory MyApartmentsState.success(List<ApartmentModel> apartments) = _Success;
  const factory MyApartmentsState.empty() = _Empty;
  const factory MyApartmentsState.error(String message) = _Error;
}
