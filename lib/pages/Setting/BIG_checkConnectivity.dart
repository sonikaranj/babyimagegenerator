import 'package:connectivity_plus/connectivity_plus.dart';

class BIG_ConnectivityService {
  static Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
