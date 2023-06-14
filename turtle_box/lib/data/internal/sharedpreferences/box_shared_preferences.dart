import 'package:shared_preferences/shared_preferences.dart';

class BoxSharedPreferences {
  final SharedPreferences sharedPreferences;

  BoxSharedPreferences({required this.sharedPreferences});

  String? getEmail() {
    return sharedPreferences.getString("email");
  }

  String? getPassword() {
    return sharedPreferences.getString("password");
  }

  String? getId() {
    return sharedPreferences.getString("id");
  }

  Future<void> setConfig(String id, String email, String password) async {
    await sharedPreferences.setString("email", email);
    await sharedPreferences.setString("password", password);
    await sharedPreferences.setString("id", id);
  }

  addTurtle(String idDevice) async {
    List<String>? turtles = sharedPreferences.getStringList("turtle");
    if (turtles != null) {
      turtles.add(idDevice);
      await sharedPreferences.setStringList("turtle", turtles);
    } else {
      await sharedPreferences.setStringList("turtle", [idDevice]);
    }
  }

  addEmergency(String idDevice) async {
    List<String>? emergencies = sharedPreferences.getStringList("emergency");
    if (emergencies != null) {
      emergencies.add(idDevice);
      await sharedPreferences.setStringList("emergency", emergencies);
    } else {
      await sharedPreferences.setStringList("emergency", [idDevice]);
    }
  }
}
