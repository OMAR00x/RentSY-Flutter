import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/user.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loadInProgress() = _LoadInProgress;
  const factory ProfileState.loadSuccess(UserModel user) = _LoadSuccess;
  const factory ProfileState.loadFailure(String message) = _LoadFailure;
  
  const factory ProfileState.updateInProgress() = _UpdateInProgress;
  
  
  const factory ProfileState.updateSuccess(UserModel updatedUser) = _UpdateSuccess;
  
  const factory ProfileState.updateFailure(String message) = _UpdateFailure;
}
