// lib/features/agent_home/cubit/add_apartment_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/apartment_model.dart';

part 'add_apartment_state.freezed.dart';

@freezed
class AddApartmentState with _$AddApartmentState {
  const factory AddApartmentState.initial() = _Initial;
  const factory AddApartmentState.loading() = _Loading;
  const factory AddApartmentState.success(ApartmentModel apartment) = _Success;
  const factory AddApartmentState.error(String message) = _Error;
}
