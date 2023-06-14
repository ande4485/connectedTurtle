import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/device_user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInit extends UserState {}

class UserNeedRegister extends UserState {}

class LoadingUser extends UserState {}

class UserFound extends UserState {
  const UserFound(this.user);

  final DeviceUser user;

  @override
  List<Object> get props => [user];
}

class UserCreated extends UserFound {
  const UserCreated(user) : super(user);

  @override
  List<Object> get props => [user];
}

class UserCreationError extends UserState {}

class UserListenError extends UserState {}

class UserUpdated extends UserState {}

class UserUpdateError extends UserState {}
