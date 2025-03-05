import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BIG_CreditsManager {
  static final storage = const FlutterSecureStorage();
  static  var uuid1="10";
  static Future<void> _initAppTrackingTransparency() async {
    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print(uuid);
    uuid1 = "Face Check ID:$uuid";
    print(uuid1);
  }
  // static var uuid1 ="10";
  static  Future<int>getUserCredits() async {
    await _initAppTrackingTransparency();
    String? creditsString = await storage.read(key: uuid1);
    return creditsString != null ? int.parse(creditsString) : 0;
  }

  static Future<void> saveUserCredits(int credits) async {
    await _initAppTrackingTransparency();
    await storage.write(key: uuid1, value: credits.toString());
  }
}
