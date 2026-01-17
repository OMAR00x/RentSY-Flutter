// lib/features/auth/cubit/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/core/domain/models/user.dart';

import '../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  UserModel? currentUser;

  AuthCubit(this._authRepository) : super(const AuthState.initial());

 
  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getAuthenticatedUser();
      if (user != null) {
        currentUser = user;
       
        switch (user.status) {
          case 'approved':
            emit(AuthState.authenticated(user));
            break;
          case 'pending':
            emit(const AuthState.pendingApproval("Your account is still under review."));
            break;
          case 'rejected':
            emit(const AuthState.rejected("Your account has been rejected."));
            break;
          default:
            emit(const AuthState.unauthenticated());
        }
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String mobileNumber, String password) async {
    try {
      emit(const AuthState.loading());
      final user = await _authRepository.login(mobileNumber, password);
      currentUser = user;
      
      switch (user.status) {
        case 'approved':
          emit(AuthState.authenticated(user));
          break;
        case 'pending':
          emit(const AuthState.pendingApproval("Your account is still under review."));
          break;
        case 'rejected':
          emit(const AuthState.rejected("Your account has been rejected. Please contact support."));
          break;
        default:
          emit(AuthState.error("Unknown user status: ${user.status}"));
      }
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    currentUser = null;
    emit(const AuthState.unauthenticated());
  }
}
