import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';

import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc({required this.authUseCase}) : super(AuthInit());

  Future<void> getAuth() async {
    try {
      emit(AuthLoading());
      AuthDeviceUser? authUser = await authUseCase.getAuth();
      if (authUser != null) {
        emit(AuthSuccess(authDeviceUser: authUser));
      } else {
        emit(AuthError());
      }
    } catch (e) {
      emit(AuthError());
    }
  }

  Future<void> isSignIn() async {
    try {
      emit(AuthLoading());
      bool isSignIn = await authUseCase.isSignIn();
      if (isSignIn) {
        AuthDeviceUser? authUser = await authUseCase.getAuth();
        if (authUser != null) {
          emit(AuthSuccess(authDeviceUser: authUser));
        } else {
          emit(AuthError());
        }
      }
      emit(AuthNoSignIn());
    } catch (e) {
      emit(AuthError());
    }
  }
}
