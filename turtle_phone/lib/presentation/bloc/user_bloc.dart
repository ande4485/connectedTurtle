import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';
import 'package:turtle_package/domain/usecase/device_user_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';
import 'package:turtle_package/model/device_user.dart';

import 'user_state.dart';

class UserBloc extends Cubit<UserState> {
  DeviceUsersUseCase userUseCase;
  AuthUseCase authUsecase;
  UserBloc({required this.userUseCase, required this.authUsecase})
      : super(UserInit());

  DeviceUser? currentUser;

  Future<void> getUser() async {
    try {
      AuthDeviceUser? authDeviceUser = await authUsecase.getAuth();
      if (authDeviceUser != null) {
        DeviceUser user = await userUseCase.getUser(authDeviceUser.id);
        emit(UserFound(user));
      }
    } catch (e) {
      emit(UserListenError());
    }
  }

  Future<void> updateUser(DeviceUser user) async {
    try {
      await userUseCase.updateUser(user);
    } catch (e) {
      emit(UserUpdateError());
    }
  }
}
