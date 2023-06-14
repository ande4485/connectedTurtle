import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turtle_package/domain/usecase/auth_usecase.dart';

import 'package:turtle_package/domain/usecase/device_user_usecase.dart';
import 'package:turtle_package/model/auth_device_user.dart';
import 'package:turtle_package/model/device_user.dart';

import 'device_users_state.dart';

class DeviceUsersBloc extends Cubit<DeviceUsersState> {
  final DeviceUsersUseCase deviceUsersUseCase;
  final AuthUseCase authUseCase;
  StreamSubscription? _usersListener;

  DeviceUsersBloc({required this.deviceUsersUseCase, required this.authUseCase})
      : super(DeviceUsersInit());

  Future<void> createInvitUser(
      String email, String idDevice, String nameDevice) async {
    emit(DeviceInvitUsersProcessing());
    try {
      await deviceUsersUseCase.createInvitation(email, idDevice, nameDevice);
      /**  if (result.answer == AnswerRequest.userNotFound) {
        return emit(DeviceCreateInvitUserNotFound());
      } else if (result.answer == AnswerRequest.userAlreadyExist) {
        return emit(DeviceInvitUserAlreadyExist());
      }*/
    } catch (e) {
      emit(InvitedUsersError());
    }
  }

  Future<void> acceptInvitation(Map<String, dynamic> invitationParams) async {
    try {
      AuthDeviceUser? user = await authUseCase.getAuth();
      if (user != null) {
        await deviceUsersUseCase.acceptInvitation(user.id, invitationParams);
      } else {
        emit(InvitedUsersError());
      }
    } catch (e) {
      emit(InvitedUsersError());
    }
  }

  Future<void> removeUserOfDevice(
      DeviceUser deviceUser, String idDevice) async {
    emit(DeviceUsersProcessing());
    try {
      await deviceUsersUseCase.removeUserOfDevice(deviceUser, idDevice);
      emit(DeviceUsersDone());
    } catch (e) {
      emit(DeviceUserError());
    }
  }

  Future<void> addUserToEmergency(
      DeviceUser deviceUser, String idDevice) async {
    emit(DeviceUsersProcessing());
    try {
      await deviceUsersUseCase.addUserToEmergency(deviceUser, idDevice);

      emit(DeviceUsersDone());
    } catch (e) {
      emit(DeviceUserError());
    }
  }

  Future<void> removeUserEmergency(
      DeviceUser deviceUser, String idDevice) async {
    emit(DeviceUserEmergencyProcessing());
    try {
      await deviceUsersUseCase.removeUserEmergency(deviceUser, idDevice);

      emit(DeviceUsersEmergencyDone());
    } catch (e) {
      emit(DeviceEmergencyUsersError());
    }
  }

  Future<void> changeAdmin(String idUser, String idDevice) async {
    emit(DeviceUsersProcessing());
    try {
      await deviceUsersUseCase.changeAdmin(idUser, idDevice);
      emit(DeviceUsersDone());
    } catch (e) {
      emit(DeviceUserError());
    }
  }

  getDeviceUsers(String idDevice) {
    emit(DeviceGetListUsers());
    try {
      _usersListener =
          deviceUsersUseCase.getDeviceUsers(idDevice).listen((listUsers) {
        emit(DeviceUsers(
            deviceUsers: listUsers.$1,
            deviceEmergencyUsers: listUsers.$3,
            invitedUsersList: listUsers.$2));
      });
    } catch (e) {
      emit(DeviceGetListError());
    }
  }

  Future<void> getUser() async {
    try {
      AuthDeviceUser? user = await authUseCase.getAuth();
      if (user != null) {
        DeviceUser deviceUser = await deviceUsersUseCase.getUser(user.id);
        emit(DeviceGetUser(deviceUser: deviceUser));
      }
    } catch (e) {
      emit(DeviceUserError());
    }
  }

  void dispose() async {
    if (_usersListener != null) await _usersListener!.cancel();
  }
}
