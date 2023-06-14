import 'package:turtle_package/data/remote/remote_auth_datasource.dart';
import 'package:turtle_package/domain/repository/auth_repository.dart';
import 'package:turtle_package/model/auth_device_user.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthDataSource remoteAuthDataSource;

  AuthRepositoryImpl({required this.remoteAuthDataSource});

  @override
  Future<AuthDeviceUser?> getAuth() {
    return remoteAuthDataSource.getAuth();
  }

  @override
  Future<bool> isSignIn() {
    return remoteAuthDataSource.isSignIn();
  }

  @override
  Future<AuthDeviceUser?> signIn(String id, String password) {
    return remoteAuthDataSource.signIn(id, password);
  }

  @override
  Future<AuthDeviceUser?> logWithAuthGoogle() {
    return remoteAuthDataSource.logWithAuthGoogle();
  }
}
