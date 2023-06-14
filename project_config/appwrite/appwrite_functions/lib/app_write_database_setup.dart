import 'package:dart_appwrite/dart_appwrite.dart';

void main() {
  // Init SDK
  Client client = Client();
  Databases databases = Databases(client);
  /**Collection collection = Collection(
      $id: $id,
      $createdAt: $createdAt,
      $updatedAt: $updatedAt,
      $permissions: $permissions,
      databaseId: databaseId,
      name: name,
      enabled: enabled,
      documentSecurity: documentSecurity,
      attributes: attributes,
      indexes: indexes);**/
  // Your secret API key
  ;

  Future resultDeviceDatabase = databases.create(
    databaseId: '[DATABASE_ID]',
    name: 'devices',
  );

  Future result = databases.create(
    databaseId: '[DATABASE_ID]',
    name: 'turtles',
  );

  result.then((response) {
    print(response);
  }).catchError((error) {
    print(error.response);
  });
}
