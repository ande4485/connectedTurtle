import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';
import 'package:turtle_package/domain/usecase/device_user_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';

import 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final AuthUseCase authUseCase;
  final DeviceUsersUseCase userUseCase;

  LoginBloc({required this.authUseCase, required this.userUseCase})
      : super(LoginInit());

  Future<void> start() async {
    try {
      emit(LoginLoading());
      bool isSignIn = await authUseCase.isSignIn();
      if (isSignIn) {
        AuthDeviceUser? authUser = await authUseCase.getAuth();
        if (authUser != null) {
          //so get user

          emit(LoginFinished(idUser: authUser.id));
        } else {
          emit(LoginNoSignin());
        }
      } else {
        emit(LoginNoSignin());
      }
    } catch (e) {
      emit(LoginError());
    }
  }

  Future<void> login() async {
    try {
      emit(LoginLoading());
      AuthDeviceUser? authUser = await authUseCase.getAuth();
      if (authUser != null) {
        emit(LoginFinished(idUser: authUser.id));
      } else {
        emit(LoginError());
      }
    } catch (e) {
      emit(LoginError());
    }
  }

  Future<void> logWithAuthGoogle() async {
    try {
      AuthDeviceUser? authUser = await authUseCase.logWithAuthGoogle();
      if (authUser != null) {
        emit(LoginFinished(idUser: authUser.id));
      } else {
        emit(LoginError());
      }
    } catch (e) {
      emit(LoginError());
    }
  }
}
