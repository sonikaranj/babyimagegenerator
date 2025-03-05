// import 'dart:convert';
//
// import 'package:babyimage/Ads/ads_variable.dart';
// import 'package:babyimage/const/global/globalapi.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
//
// import 'firebase_options.dart';
//
// Future<void> firebaseConfigure() async {
//   print("configmessage");
//   try {
//     print("configtry");
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//
//     print("firebase init");
//     final remoteConfig = FirebaseRemoteConfig.instance;
//
//     await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(minutes: 1),
//       minimumFetchInterval: const Duration(minutes: 5),
//     ));
//     await remoteConfig.fetchAndActivate();
//     Map<String, dynamic> mapValues1 = jsonDecode(remoteConfig.getValue("key").asString());
//     print('yyyy ${mapValues1}');
//     print(mapValues1["fb_appid"]);
//     print("facebook");
//     final facebookId = mapValues1["big_facebookId"];
//     final facebookCode = mapValues1["big_facebookToken"];
//
//
//     callAndroidMethod(facebookId, facebookCode);
//     FlutterError.onError = (errorDetails) {
//       FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
//     };
//     PlatformDispatcher.instance.onError = (error, stack) {
//       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//       return true;
//     };
//   } on Exception catch (e) {
//     print(e);
//     print("sserror");
//     return;
//   }
// }
//
//
// callAndroidMethod(String facid, String faccode) {
//   print("Call 1");
//   const platformMethodChannel = MethodChannel('nativeChannel');
//   print("Call 2");
//   platformMethodChannel.invokeMethod('setToast', {
//     'fb_appid': facid,
//     'fb_token': faccode,
//   });
//   print("Call 3");
// }
