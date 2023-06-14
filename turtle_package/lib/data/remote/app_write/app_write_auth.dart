import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:turtle_package/data/remote/remote_auth_datasource.dart';
import 'package:turtle_package/model/auth_device_user.dart';

class AppWriteAuth extends RemoteAuthDataSource {
  final Account account;

  AppWriteAuth({required this.account});

  @override
  Future<AuthDeviceUser?> getAuth() async {
    try {
      User user = await account.get();
      return AuthDeviceUser(id: user.$id);
    } on Exception {
      return null;
    }
  }

  @override
  Future<bool> isSignIn() async {
    try {
      await account.get();
    } on Exception {
      return false;
    }
    return true;
  }

  @override
  Future<AuthDeviceUser?> signIn(String id, String password) async {
    await account.createEmailSession(email: id, password: password);
    User user = await account.get();
    return AuthDeviceUser(id: user.$id);
  }

  Future<AuthDeviceUser?> logWithAuthGoogle() async {
    await account.createOAuth2Session(provider: "google");
    User user = await account.get();
    return AuthDeviceUser(id: user.$id);
  }
}
