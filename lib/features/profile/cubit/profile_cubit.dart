import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/features/auth/repository/auth_repository.dart';
import 'package:saved/features/profile/cubit/profile_state.dart';
import 'package:saved/features/profile/repository/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  ProfileCubit(this._authRepository, this._profileRepository) 
      : super(const ProfileState.initial()); // ✨ استخدام الحالة الجديدة

  Future<void> fetchProfile() async {
    emit(const ProfileState.loadInProgress()); // ✨ استخدام الحالة الجديدة
    try {
      final user = await _authRepository.getAuthenticatedUser();
      if (user != null) {
        emit(ProfileState.loadSuccess(user)); // ✨ استخدام الحالة الجديدة
      } else {
        emit(const ProfileState.loadFailure("User not authenticated.")); // ✨ استخدام الحالة الجديدة
      }
    } catch (e) {
      emit(ProfileState.loadFailure("Failed to load profile: ${e.toString()}")); // ✨ استخدام الحالة الجديدة
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? password,
    File? avatar,
  }) async {
    emit(const ProfileState.updateInProgress()); // ✨ استخدام الحالة الجديدة
    try {
      final updatedUser = await _profileRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        password: password,
        avatar: avatar,
      );
      // بعد النجاح، نرجع إلى حالة النجاح مع البيانات المحدثة
      emit(ProfileState.updateSuccess(updatedUser));
    } catch (e) {
      emit(ProfileState.updateFailure(e.toString()));
    }
  }
}