
import 'package:equatable/equatable.dart';
import 'package:turtle_package/model/auth_device_user.dart';

abstract class AuthState extends Equatable {

  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInit extends AuthState{}

class AuthSuccess extends AuthState{

  final AuthDeviceUser authDeviceUser;
  const AuthSuccess({required this.authDeviceUser});

  @override
  List<Object> get props => [authDeviceUser];

}

class AuthNoSignIn extends AuthState{

}

class AuthError extends AuthState{}

class AuthLoading extends AuthState{}