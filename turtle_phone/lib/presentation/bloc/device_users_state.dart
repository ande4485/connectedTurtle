import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/device_user.dart';

class DeviceUsersState extends Equatable {
  const DeviceUsersState();

  @override
  List<Object> get props => [];
}

class DeviceUsersInit extends DeviceUsersState {}

class DeviceGetListUsers extends DeviceUsersState {}

class DeviceGetUser extends DeviceUsersState {
  final DeviceUser deviceUser;
  const DeviceGetUser({required this.deviceUser});

  @override
  List<Object> get props => [deviceUser];
}

class DeviceUsers extends DeviceUsersState {
  final List<DeviceUser> deviceUsers;
  final List<DeviceUser> invitedUsersList;

  final List<DeviceUser> deviceEmergencyUsers;

  const DeviceUsers(
      {required this.deviceUsers,
      required this.invitedUsersList,
      required this.deviceEmergencyUsers});

  @override
  List<Object> get props =>
      [deviceUsers, invitedUsersList, deviceEmergencyUsers];
}

class DeviceGetListError extends DeviceUsersState {}

//Emergency user
class DeviceEmergencyUsersError extends DeviceUsersState {}

class DeviceUsersEmergencyDone extends DeviceUsersState {}

class DeviceUserEmergencyProcessing extends DeviceUsersState {}

//Device users

class DeviceUserError extends DeviceUsersState {}

class DeviceUsersDone extends DeviceUsersState {}

class DeviceUsersProcessing extends DeviceUsersState {}

//Invited users

class InvitedUsersError extends DeviceUsersState {}

class InvitedUsersDone extends DeviceUsersState {}

class DeviceCreateInvitUserNotFound extends DeviceUsersState {}

class DeviceInvitUsersProcessing extends DeviceUsersState {}

class DeviceInvitUserAlreadyExist extends DeviceUsersState {}
