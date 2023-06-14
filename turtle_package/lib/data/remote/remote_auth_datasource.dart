import 'package:turtle_package/model/auth_device_user.dart';

abstract class RemoteAuthDataSource {
  Future<AuthDeviceUser?> getAuth();

  Future<bool> isSignIn();

  Future<AuthDeviceUser?> signIn(String id, String password);

  Future<AuthDeviceUser?> logWithAuthGoogle();
}
