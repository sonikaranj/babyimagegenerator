import 'dart:io';

import 'package:babyimage/Ads/ads_variable.dart';
import 'package:babyimage/Firebase/firebase.dart';
import 'package:babyimage/const/page/page.dart';
import 'package:babyimage/controller/Home_controller.dart';
import 'package:babyimage/controller/Splash_controller.dart';
import 'package:babyimage/them/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'Ads/app_open_ad.dart';
import 'Ads/life_cycle.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //         apiKey: 'AIzaSyBky4cCNW-4qeGkCXysd6HAqWyn0NHto6c',
  //         appId: '1:956400082004:android:77130d81b7cf0d0ac221c1',
  //         messagingSenderId: '956400082004',
  //         projectId: 'babyimagegenerate',
  //         storageBucket: 'babyimagegenerate.appspot.com',
  //       )
  //   );
  // }
  // else if (Platform.isIOS) {
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //         apiKey: 'AIzaSyBky4cCNW-4qeGkCXysd6HAqWyn0NHto6c',
  //         appId: '1:956400082004:android:77130d81b7cf0d0ac221c1',
  //         messagingSenderId: '956400082004',
  //         projectId: 'babyimagegenerate',
  //         storageBucket: 'babyimagegenerate.appspot.com',
  //       ));
  // }
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    // TODO: implement initState
    // WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // setLocale(Locale(AdsVariable.languageCode));
      print("karansoni");
      _appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      _appLifecycleReactor.listenToAppStateChanges(shouldShow: true);
    });
    print("firebasecall");
    _fetchRemoteConfig();
    print("firebasecallend");
    super.initState();
  }


  Future<void> _fetchRemoteConfig() async {
    try {
      // print("firebasecalltry");
      // // Initialize Remote Config
      // final remoteConfig = FirebaseRemoteConfig.instance;
      // print(remoteConfig);
      // // Set default parameters if necessary
      // await remoteConfig.setDefaults({
      //   'welcome_message': 'Welcome to my app!',
      //   'is_feature_enabled': false,
      // });
      //
      // // Fetch the latest Remote Config values from the server
      // await remoteConfig.fetchAndActivate();
      //
      // // Get values from Remote Config
      // print("message");
      // String key = remoteConfig.getString('key');
      //
      // print(key);
      // firebaseConfigure();

    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }


  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // App is resumed from the background
  //     print("sonikaranssss");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1242,2208),
      child: GetMaterialApp(
        theme: ThemeData(
            fontFamily: 'RedHatDisplay'
        ),
        initialRoute: AppRoutes.SPLASH,
        getPages: AppPages.pages,
        initialBinding: InitialBindings(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
   Get.put(() => SplashController());
   Get.put(() => HomeController());
  }
}