import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:babyimage/Ads/ads_load_util.dart';
import 'package:babyimage/Ads/ads_splash_utils.dart';
import 'package:babyimage/Ads/ads_variable.dart';
import 'package:babyimage/Ads/nativeAdService.dart';
import 'package:babyimage/Inapppurchase/app.dart';
import 'package:babyimage/const/global/globalapi.dart';
import 'package:babyimage/pages/BIG_Homepage.dart';
import 'package:babyimage/Inapppurchase/credit/BIG_InappPurchase.dart';
import 'package:babyimage/pages/OnBoarding/BIG_OnBoardingScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/src/ad_containers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Setting/BIG_sharedPreferencesService.dart';

class BIG_SplashPage extends StatefulWidget {
  const BIG_SplashPage({super.key});

  @override
  State<BIG_SplashPage> createState() => _BIG_SplashPageState();
}

class _BIG_SplashPageState extends State<BIG_SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late final Animation<AlignmentGeometry> _alignAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _alignAnimation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));
    print("hello");

    if (Platform.isIOS) {
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((_) => _initAppTrackingTransparency());
    }

    // _fetchApiKey();
    // loadPreLoadAds();
    if (AdsVariable.isPurchase == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if (await checkConnectivity()) {
          await AdsSplashUtils().getOnlineIds(
            () {
              loadPreLoadAds();
            },
            () {
              navigatescreen();
            },
          );
        } else {
          await Future.delayed(Duration(seconds: 8));
          navigatescreen();
        }
      });
    }
  }

  String? uuid1;
  Future<void> _initAppTrackingTransparency() async {
    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print(uuid);
    uuid1 = "Face Check ID:$uuid";
    print(uuid1);
  }

  bool isLogin = false;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _loadLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool('isLogin') ?? false;
    });
  }

  void loadPreLoadAds() async {
    print("sonkaran");
    BIG_SharedPreferencesService.getUser().then((value) {
      print("ssssssss");
      if (value.isEmpty && AdsVariable.big_nativeAd_intro != '11') {
        NativeAdService.loadNativeAd(AdsVariable.big_nativeAd_intro_ios);
      }
    });
    // setState(() {});
  }

  navigatescreen() {
    (isLogin!)
        ? (AdsVariable.isPurchase)
            ? Get.off(() => BIG_Homepage())
            : Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BIG_Inapppurchase(
                  item: false,
                  credit: false,
                ),
              ))
        : Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BIG_OnBoardingScreen(),
          ));
  }

  Future<bool> checkConnectivity() async {
    ConnectivityResult? connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 2208.h,
        width: 1242.w,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/sc_6/bg.png'), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 1565.h,
                width: 1242.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/splash/logo.png'),
                        fit: BoxFit.contain)),
              ),
              Container(
                height: 95.h,
                width: 808.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/splash/Ai Baby Generator.png'),
                        fit: BoxFit.contain)),
              ),
              Spacer(),
              Container(
                height: 20.h,
                width: 900.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/splash/seekbar_uufill.png'))),
                child: AlignTransition(
                  alignment: _alignAnimation,
                  child: Image(
                    image: AssetImage('assets/splash/seekbar_fill.png'),
                    height: 20.h,
                    width: 195.w,
                  ),
                ),
              ).marginOnly(bottom: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}

//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:babyimage/Ads/ads_load_util.dart';
// import 'package:babyimage/Ads/ads_splash_utils.dart';
// import 'package:babyimage/Ads/ads_variable.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'package:get/get.dart';
//
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});
//
//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }
//
// class _SplashscreenState extends State<Splashscreen> {
//   bool _isError = false;
//
//   Future<void> getvariable() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     print("++++++++++++++++++++++++++");
//     print("++++++++++++++++++++++++++");
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getvariable();
//
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       print("11111111");
//       if (await checkConnectivity()) {
//         await AdsSplashUtils().getOnlineIds(
//               () {
//             loadPreLoadAds();
//           },
//               () {
//             // navigatescreen();
//           },
//         );
//         //   await AdsLoadUtil().loadInterSplash(() {loadPreLoadAds();}, () {navigateScreen();},
//         //       Platform.isAndroid
//         //           ? AdsVariable.interSplash
//         //           : AdsVariable.interSplashIOS);
//       } else {
//         await Future.delayed(Duration(seconds: 8));
//         // navigatescreen();
//       }
//     });
//   }
//
//
//   void loadPreLoadAds() async {
//     print("Call Method loadPreLoadAds");
//     print("AdsVariable.isFirstTime---->");
//
//       AdsVariable.nativeAd = await AdsLoadUtil().loadNative(
//           Platform.isAndroid
//               ? AdsVariable.big_nativeAd
//               : AdsVariable.big_nativeAd_ios,
//           true);
//     // } else {
//     //   print("12346");
//     //   AdsVariable.nativeAdLanguage = await AdsLoadUtil()
//     //       .loadNative(AdsVariable.SV_native_language_screen, false);
//     // }
//     setState(() {});
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//   }
//
//   Future<bool> checkConnectivity() async {
//     ConnectivityResult? connectivityResult =
//     await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       return false;
//     } else if (connectivityResult == ConnectivityResult.wifi ||
//         connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.ethernet) {
//       return true;
//     }
//     return false;
//   }
//
//   // navigatescreen() {
//   //   (isdone!)
//   //       ? (AdsVariable.isPurchase)
//   //       ? Navigator.of(context).pushReplacement(MaterialPageRoute(
//   //     builder: (context) => TempviewPage(),
//   //   ))
//   //       : Navigator.of(context).pushReplacement(MaterialPageRoute(
//   //     builder: (context) => UpsellScreen(item: false),
//   //   ))
//   //       : Navigator.of(context).pushReplacement(MaterialPageRoute(
//   //     builder: (context) => Language_screen(IsFrom: 'splash'),
//   //   ));
//   // }
//
//   // @override
//   // void dispose() {
//   //   _controller.dispose();
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           _isError
//               ? Center(child: Text('Failed to load video'))
//               : Container(
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image(
//                 image: AssetImage('assets/splash/logo.png'),
//                 height: 285.h,
//                 width: 285.w,
//               ),
//               SizedBox(height: 60.h),
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'LIVE\n'.tr,
//                       style: TextStyle(
//                         fontSize: 120.sp, // Adjusted size
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 7.0,
//                         shadows: const [
//                           Shadow(
//                             // Adding red shadow for border effect
//                             offset: Offset(-3.0, -1.0),
//                             color: Colors.red,
//                             blurRadius: 1.0,
//                           ),
//                           Shadow(
//                             offset: Offset(1.0, -1.0),
//                             color: Colors.red,
//                             blurRadius: 1.0,
//                           ),
//                           Shadow(
//                             offset: Offset(0.6, 1.0),
//                             color: Colors.red,
//                             blurRadius: 1.0,
//                           ),
//                           Shadow(
//                             offset: Offset(-3.0, 0.8),
//                             color: Colors.red,
//                             blurRadius: 1.0,
//                           ),
//                         ], // Add spacing between letters
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Street View On Earth Map'.tr,
//                       style: TextStyle(
//                         color: Color(0xffffffff),
//                         fontSize: 65.sp, // Adjusted size
//                         fontWeight: FontWeight.normal,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 150.h,
//             child: Text(
//               'This action may contain ads...'.tr,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 35.sp,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
