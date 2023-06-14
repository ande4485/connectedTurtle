import 'package:appwrite/appwrite.dart';
import 'package:turtle_package/data/remote/remote_box_create_datasource.dart';

import 'package:uuid/uuid.dart';

class AppWriteCreateBox extends RemoteBoxCreateDataSource {
  final Account accountAdmin;

  AppWriteCreateBox({required this.accountAdmin});

  @override
  Future<(String email, String password, String idBox)> create() async {
    var uuidBox = const Uuid().v4();
    String email = "$uuidBox@box-turtle.com";
    var password = const Uuid().v4();

    var user = await accountAdmin.create(
        userId: ID.unique(), email: email, password: password);
    return (email, password, user.$id);
  }
}
