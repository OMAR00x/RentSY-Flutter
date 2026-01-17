import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/features/auth/repository/auth_repository.dart';
import 'package:saved/features/profile/cubit/profile_state.dart';
import 'package:saved/features/profile/repository/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  ProfileCubit(this._authRepository, this._profileRepository) 
      : super(const ProfileState.initial()); 

  Future<void> fetchProfile() async {
    emit(const ProfileState.loadInProgress()); 
    try {
      final user = await _authRepository.getAuthenticatedUser();
      if (user != null) {
        emit(ProfileState.loadSuccess(user)); 
      } else {
        emit(const ProfileState.loadFailure("User not authenticated.")); 
      }
    } catch (e) {
      emit(ProfileState.loadFailure("Failed to load profile: ${e.toString()}")); 
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    String? password,
    File? avatar,
  }) async {
    emit(const ProfileState.updateInProgress()); 
    try {
      final updatedUser = await _profileRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        password: password,
        avatar: avatar,
      );
     
      emit(ProfileState.updateSuccess(updatedUser));
    } catch (e) {
      emit(ProfileState.updateFailure(e.toString()));
    }
  }
}