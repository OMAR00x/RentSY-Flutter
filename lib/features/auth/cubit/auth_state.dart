import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/user.dart';



part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserModel user) = _Authenticated; // ✨ تعديل
  const factory AuthState.pendingApproval(String message) = _PendingApproval;
  const factory AuthState.rejected(String message) = _Rejected; // ✨ إضافة
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}
