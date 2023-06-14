import 'package:turtle_package/domain/repository/box_repository.dart';

import 'internal/sharedpreferences/box_shared_preferences.dart';

class BoxRepositoryImpl extends BoxRepository {
  final BoxSharedPreferences boxSharedPreferences;

  BoxRepositoryImpl({required this.boxSharedPreferences});

  @override
  String? getEmail() {
    return boxSharedPreferences.getEmail();
  }

  @override
  String? getPassword() {
    return boxSharedPreferences.getPassword();
  }

  @override
  String? getId() {
    return boxSharedPreferences.getId();
  }

  @override
  Future<void> setConfig(String id, String email, String password) {
    return boxSharedPreferences.setConfig(id, email, password);
  }

  @override
  Future<void> addTurtle(String idDevice) {
    return boxSharedPreferences.addTurtle(idDevice);
  }

  @override
  Future<void> addEmergency(String idDevice) {
    return boxSharedPreferences.addEmergency(idDevice);
  }
}
