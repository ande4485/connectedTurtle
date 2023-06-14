abstract class BoxRepository {
  String? getEmail();

  String? getPassword();

  Future<void> setEmailAndPassword(String email, String password);

  Future<void> addDevice(String idTurtle, String idFirebase);

  Future<String> getIdDevice(String idTurtle);
}
