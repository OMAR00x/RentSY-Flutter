import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved/core/domain/models/user.dart';
 

import '../repository/register_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> { // ✨ تحديد النوع
  final RegisterRepository _registerRepository;

  RegisterCubit(this._registerRepository) : super(const RegisterState.initial());

  Future<void> submitRegistration({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String birthdate,
    required String role,
    required XFile avatar,
    required XFile idFront,
    required XFile idBack,
  }) async {
    try {
      emit(const RegisterState.loading());
      UserModel user = await _registerRepository.register(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        birthdate: birthdate,
        role: role,
        avatar: avatar,
        idFront: idFront,
        idBack: idBack,
      );
      emit(RegisterState.success(user));
    } catch (e) {
      emit(RegisterState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
