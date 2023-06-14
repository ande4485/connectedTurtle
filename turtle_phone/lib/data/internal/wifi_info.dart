import 'package:network_info_plus/network_info_plus.dart';

import '../../domain/config/wifi_information.dart';

class WifiInfo extends WifiInformation {
  @override
  Future<String?> getSSid() {
    return NetworkInfo().getWifiName();
  }
}
