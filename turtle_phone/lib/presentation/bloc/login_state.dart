import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInit extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFinished extends LoginState {
  final String idUser;

  const LoginFinished({required this.idUser});

  @override
  List<Object> get props => [idUser];
}

class LoginError extends LoginState {}

class LoginNoSignin extends LoginState {}
