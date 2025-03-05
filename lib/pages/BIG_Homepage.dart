import 'dart:io';

import 'package:babyimage/Ads/ads_variable.dart';
import 'package:babyimage/Inapppurchase/credit/BIG_creditManager.dart';
import 'package:babyimage/Inapppurchase/credit/BIG_cut_credit.dart';
import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/Inapppurchase/credit/BIG_CreditPurchase.dart';
import 'package:babyimage/Inapppurchase/credit/BIG_InappPurchase.dart';
import 'package:babyimage/pages/celebritydetection/BIG_Celebrityfind.dart';
import 'package:babyimage/pages/Setting/BIG_SettingsScreen.dart';
import 'package:babyimage/pages/Babylooks/BIG_Babylooks.dart';
import 'package:babyimage/pages/Babygenerator/BIG_Babyimagegeneratorapi.dart';
import 'package:babyimage/pages/agedetection/BIG_Ageandgender.dart';
import 'package:babyimage/pages/babyname/BIG_Babynamgeneator.dart';
import 'package:babyimage/pages/BIG_imagetourl.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:babyimage/services/BIG_Sharepreferance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Ads/ads_load_util.dart';
import '../Ads/app_open_ad.dart';
import '../Ads/life_cycle.dart';
import '../Ads/nativeAdService.dart';
import '../services/BIG_Shimmer.dart';

class BIG_Homepage extends StatefulWidget {
  const BIG_Homepage({super.key});

  @override
  State<BIG_Homepage> createState() => _BIG_HomepageState();
}

class _BIG_HomepageState extends State<BIG_Homepage> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late AppLifecycleReactor appLifecycleListener;
  String data = '';

  setupNotification() {
    const platformMethodChannel = MethodChannel('notificationChannel');
    platformMethodChannel.invokeMethod('setNotification', {
      'isPurchase': AdsVariable.isPurchase.toString(),
    });
  }

  gdprAvailable() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    ConsentInformation.instance
        .requestConsentInfoUpdate(ConsentRequestParameters(), () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        await preferences.setString('keyvalue', "1");
        data = (preferences.getString('keyvalue'))!;
      } else {
        await preferences.setString('keyvalue', "0");
        data = (preferences.getString('keyvalue'))!;
      }
    }, (error) {
      if (kDebugMode) {
        print("error");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    appLifecycleListener =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    appLifecycleListener.listenToAppStateChanges(shouldShow: true);

    if (AdsVariable.isPurchase == false) {
      if (Platform.isAndroid) {
        if (AdsVariable.big_nativeAd_home != '11') {
          NativeAdService.loadNativeAd(AdsVariable.big_nativeAd_home);
        }
      } else if (Platform.isIOS) {
        if (AdsVariable.big_nativeAd_home_ios != '11') {
          NativeAdService.loadNativeAd(AdsVariable.big_nativeAd_home_ios);
        }
      }
    }
    Getcredit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setupNotification();
      gdprAvailable();
    });
  }

  int credit = 0;

  Future<void> Getcredit() async {
    int userCredits = await BIG_CreditsManager.getUserCredits();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        credit = userCredits;
      });
    });

    print('User Credits: $userCredits');
    print("soni");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: LightThemeColors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    // AdsLoadUtil.onShowAds(context, ()async{
                    //   if(await AdsLoadUtil.checkConnectivity()){
                    //   AppOpenAdManager appOpenAdManager = AppOpenAdManager();
                    //   AppLifecycleReactor appLifecycleListener =
                    //   AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
                    //   appLifecycleListener.listenToAppStateChanges( shouldShow: false);
                    //   Navigator.of(context)
                    //       .push(MaterialPageRoute(builder: (_) => BabyGeneratorScreen()))
                    //       .then((onValue) {
                    //   appLifecycleListener.listenToAppStateChanges( shouldShow: true);
                    //   });
                    //   }else{
                    //   Fluttertoast.showToast(msg: "Please Turn On Internet");
                    //   }
                    // });
                    AdsLoadUtil.onShowAds(context, () async {
                      var credit =
                          await Get.to(() => BIG_BabyGeneratorScreen());
                      print("sax");
                      print(credit);
                      if (credit == null) {
                        await Getcredit();
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/sc_5/baby generator.gif',
                      width: 1242.w,
                      height: 1020.w,
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 239.w,
                          height: 51.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/sc_5/BABY.ai.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            BIG_PressUnpress(
                              onTap: () async {
                                if (await AdsLoadUtil.checkConnectivity()) {
                                  AppOpenAdManager appOpenAdManager =
                                      AppOpenAdManager();
                                  AppLifecycleReactor appLifecycleListener =
                                      AppLifecycleReactor(
                                          appOpenAdManager: appOpenAdManager);
                                  appLifecycleListener.listenToAppStateChanges(
                                      shouldShow: false);
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => BIG_SettingsScreen(
                                                data: data,
                                              )))
                                      .then((onValue) {
                                    appLifecycleListener
                                        .listenToAppStateChanges(
                                            shouldShow: true);
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please Turn On Internet");
                                }
                              },
                              height: 100.h,
                              width: 100.w,
                              imageAssetPress: 'assets/sc_5/menu_press.png',
                              imageAssetUnPress: 'assets/sc_5/menu_unpress.png',
                            ).marginOnly(right: 20.w),
                            // PressUnpress(
                            //   onTap: () async{
                            //     BigCutCredit.addCredit(50);
                            //   },
                            //   height: 100.h,
                            //   width: 100.w,
                            //   imageAssetPress: 'assets/sc_5/menu_press.png',
                            //   imageAssetUnPress: 'assets/sc_5/menu_unpress.png',
                            // ).marginOnly(right: 20.w),
                            BIG_PressUnpress(
                              onTap: () async {
                                var coinupdate = await Get.to(
                                    () => BIG_Creditpurchase(item: true));
                                if (coinupdate == null) {
                                  await Getcredit();
                                }
                              },
                              height: 90.h,
                              width: 230.w,
                              unPressColor: Colors.yellow,
                              pressColor: Colors.orangeAccent,
                              child: Center(
                                  child: Text(
                                "${credit}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )),
                            ).marginOnly(right: 20.w),
                            BIG_PressUnpress(
                              onTap: () async {
                                if (await AdsLoadUtil.checkConnectivity()) {
                                  AppOpenAdManager appOpenAdManager =
                                      AppOpenAdManager();
                                  AppLifecycleReactor appLifecycleListener =
                                      AppLifecycleReactor(
                                          appOpenAdManager: appOpenAdManager);
                                  appLifecycleListener.listenToAppStateChanges(
                                      shouldShow: false);
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => BIG_Inapppurchase(
                                                item: true,
                                                home: true,
                                              )))
                                      .then((onValue) {
                                    appLifecycleListener
                                        .listenToAppStateChanges(
                                            shouldShow: true);
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please Turn On Internet");
                                }
                                // Get.to(() => Inapppurchase(item: true,));
                              },
                              height: 100.h,
                              width: 230.w,
                              imageAssetPress: 'assets/sc_5/pro_press.png',
                              imageAssetUnPress: 'assets/sc_5/pro_unpress.png',
                            ).marginOnly(right: 50.w),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Other Features",
                  style: TextStyle(
                    color: LightThemeColors.white,
                    fontSize: 60.sp,
                  ),
                ).marginOnly(left: 20),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BIG_PressUnpress(
                      onTap: () async {
                        print("ssaaaaa");
                        AdsLoadUtil.onShowAds(context, () async {
                          var coinupdate = await Get.to(() => BIG_BabyLooks());
                          if (coinupdate == null) {
                            await Getcredit();
                          }
                        });
                        // AdsLoadUtil.onShowAds(context, (){
                        //   Get.to(() =>  BabyLooks());
                        // });
                      },
                      height: 474.h,
                      width: 1100.w,
                      imageAssetPress: 'assets/sc_5/ai baby looks_press.png',
                      imageAssetUnPress:
                          'assets/sc_5/ai baby looks_unpress.png',
                    ),
                    if (!AdsVariable.isPurchase)
                      ValueListenableBuilder<bool>(
                        valueListenable: NativeAdService.loaded,
                        builder: (context, loaded, _) {
                          if (loaded && AdsVariable.big_nativeAd_home != '11') {
                            final Container adContainer = Container(
                              alignment: Alignment.center,
                              width: 1100.w,
                              height: 475.h,
                              child: AdWidget(ad: NativeAdService.nativeAd!),
                            );
                            return adContainer;
                          } else if (!NativeAdService.loaded.value &&
                              AdsVariable.big_nativeAd_home != '11') {
                            return Container(
                                alignment: Alignment.center,
                                width: 1100.w,
                                height: 425.h,
                                child: BIG_ShimmerSmallNative());
                          } else {
                            return SizedBox(height: 0.h);
                          }
                        },
                      ),
                    //
                    BIG_PressUnpress(
                      onTap: () async {
                        AdsLoadUtil.onShowAds(context, () async {
                          var coinupdate =
                              await Get.to(() => BIG_BabyNameGenerator());
                          ;
                          if (coinupdate == null) {
                            await Getcredit();
                          }
                        });
                      },
                      height: 474.h,
                      width: 1100.w,
                      imageAssetPress:
                          'assets/sc_5/babynamegenerator_press.png',
                      imageAssetUnPress:
                          'assets/sc_5/babynamegenerator_unpress.png',
                    ),
                    BIG_PressUnpress(
                      onTap: () async {
                        AdsLoadUtil.onShowAds(context, () async {
                          var coinupdate =
                              await Get.to(() => BigAgeandgender());
                          if (coinupdate == null) {
                            await Getcredit();
                          }
                        });
                      },
                      height: 474.h,
                      width: 1100.w,
                      imageAssetPress: 'assets/sc_5/agedetection_press.png',
                      imageAssetUnPress: 'assets/sc_5/agedetection_unpress.png',
                    ),
                    BIG_PressUnpress(
                      onTap: () async {
                        AdsLoadUtil.onShowAds(context, () async {
                          var coinupdate =
                              await Get.to(() => BIG_Celebrityfind());
                          if (coinupdate == null) {
                            await Getcredit();
                          }
                        });
                      },
                      height: 474.h,
                      width: 1100.w,
                      imageAssetPress:
                          'assets/sc_5/celebritydetection_press.png',
                      imageAssetUnPress:
                          'assets/sc_5/celebritydetection_unpress.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
