import 'package:turtle_package/domain/repository/auth_repository.dart';
import 'package:turtle_package/model/auth_device_user.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase({required this.repository});

  Future<AuthDeviceUser?> getAuth() {
    return repository.getAuth();
  }

  Future<bool> isSignIn() {
    return repository.isSignIn();
  }

  Future<AuthDeviceUser?> signIn(String id, String password) {
    return repository.signIn(id, password);
  }

  Future<AuthDeviceUser?> logWithAuthGoogle() {
    return repository.logWithAuthGoogle();
  }
}
