import 'dart:io';

import 'package:turtle_box/domain/config/box_config.dart';

class LocalBoxConfig extends BoxConfiguration {
  @override
  Future<String> getIp() async {
    var listNetwork = await NetworkInterface.list();
    String ip = "";
    bool ipFound = false;
    for (var i = 0; i < listNetwork.length; i++) {
      for (var address in listNetwork[i].addresses) {
        if (address.address.isNotEmpty) {
          ip = address.address;
          ipFound = true;
          break;
        }
      }
      if (ipFound) break;
    }
    return ip;
  }
}
