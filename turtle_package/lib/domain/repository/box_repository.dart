abstract class BoxRepository {
  String? getEmail();

  String? getPassword();

  @override
  String? getId();

  Future<void> setConfig(String id, String email, String password);

  Future<void> addTurtle(String idDevice);

  Future<void> addEmergency(String idDevice);
}
