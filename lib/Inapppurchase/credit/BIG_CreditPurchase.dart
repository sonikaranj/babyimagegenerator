import 'package:babyimage/Ads/ads_load_util.dart';
import 'package:babyimage/Ads/ads_variable.dart';
import 'package:babyimage/Inapppurchase/credit/BIG_creditManager.dart';
import 'package:babyimage/pages/BIG_Homepage.dart';
import 'package:babyimage/pages/Setting/BIG_TernsOfUse.dart';
import 'package:babyimage/pages/Setting/BIG_privacy_policy.dart';
import 'package:babyimage/pages/Setting/BIG_sharedPreferencesService.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../Ads/app_open_ad.dart';
import '../../Ads/life_cycle.dart';
import '../app.dart';
import '../constant.dart';
import '../initPlatformState.dart';
import '../../services/BIG_Dialog.dart';

class BIG_Creditpurchase extends StatefulWidget {
  final bool item;
  final bool? home;
  final bool? credit;
  const BIG_Creditpurchase({super.key, required this.item, this.credit, this.home});

  @override
  State<BIG_Creditpurchase> createState() => _InapppurchaseState();
}

class _InapppurchaseState extends State<BIG_Creditpurchase> {
  Offerings? _offerings;
  bool week = true;
  bool onemonth = true;
  bool threeweek = true;
  bool isClose = false;
  Map<String, Package>? availablePackages;
  Map<String, Package>? packageEntry;
  Package? selectedPackage  ;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late AppLifecycleReactor _appLifecycleReactor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(AdsVariable.isPurchase == false){
      AdsLoadUtil.loadPreInterstitialAd(adId: AdsVariable.big_pre_interstitialAd);
    }
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        close = true;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      _appLifecycleReactor.listenToAppStateChanges(shouldShow: false);
      // creditManager.loadCredits();
    });

    fetchData();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isClose = true;
      });
    });
  }

  Future<void> fetchData() async {
    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
      if (kDebugMode) {
        printJson(offerings.toJson());
      }
      availablePackages = {
        for (var package in offerings.current?.availablePackages ?? [])
          package.identifier: package
      };
      if ((availablePackages?.entries ?? []).length >= 2) {
        selectedPackage = (availablePackages?.entries ?? []).elementAt(1).value;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    setState(() {
      _offerings = offerings;
    });
  }

  void printJson(Map<String, dynamic>? json, [int indentation = 0]) {
    json?.forEach((key, value) {
      print('${' ' * indentation}$key: $value');
      if (value is Map<String, dynamic>) {
        printJson(value, indentation + 2);
      }
    });
  }

  int selectimageindex = 2;
  bool close = false;
  @override
  Widget build(BuildContext context) {
    if (_offerings != null) {
      final offering = _offerings!.current;
      return   WillPopScope(
        onWillPop: () async{
          Get.back();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.red,
          body: Container(
            height: 2208.h,
            width: 1242.w,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('assets/sc_6/bg.png'),
            //     fit: BoxFit.fill,
            //   ),
            // ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 980.h,
                      width: 1242.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/sc_24/logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                        right: 30.w,
                        top: 150.h,
                        child: GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child:  close == true ?  Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40.h,
                                  width: 40.h,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('assets/sc_24/cancel_unpress.png'))
                                  ),
                                ),
                              )
                          ): SizedBox.shrink(),
                        )),
                    Positioned(
                      bottom: 150.h,
                      left: 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 52.h,
                            width: 563.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                AssetImage('assets/sc_24/fast processing.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ).marginOnly(right: 50.w),
                          Container(
                            height: 51.h,
                            width: 443.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/sc_24/unlock pro.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 80.h,
                      left: 360.w,
                      child: Center(
                        child: Container(
                          height: 52.h,
                          width: 610.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/sc_24/ads.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Stack(
                  clipBehavior: Clip.none, // Prevent clipping
                  children: [
                    Center(
                      child: Container(
                        height: 720.h,
                        width: 1118.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/sc_24/plans_box.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectimageindex = 1;
                                    });
                                  },
                                  child: Container(
                                    height: 300.h,
                                    width: 480.w,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image: AssetImage(selectimageindex == 1
                                            ? 'assets/sc_24/button_unpress_bg-1.png'
                                            : 'assets/sc_24/button_unpress_bg.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "100 Week",
                                          style: TextStyle(color: Colors.white),
                                        ).marginOnly(bottom: 10.h),
                                        Container(
                                          height: 3.h,
                                          width: 243.w,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/sc_24/divider.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '\$ 99',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 80.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Pay for weekly base",
                                          style: TextStyle(
                                              color: Color(0xFF464646),
                                              fontSize: 35.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectimageindex = 2;
                                    });
                                  },
                                  child: Container(
                                    height: 300.h,
                                    width: 480.w,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image: AssetImage(selectimageindex == 2
                                            ? 'assets/sc_24/button_unpress_bg-1.png'
                                            : 'assets/sc_24/button_unpress_bg.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "1 Month",
                                          style: TextStyle(color: Colors.white),
                                        ).marginOnly(bottom: 10.h),
                                        Container(
                                          height: 3.h,
                                          width: 243.w,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/sc_24/divider.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '\$ 999',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 80.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Pay for Monthly base",
                                          style: TextStyle(
                                              color: Color(0xFF464646),
                                              fontSize: 35.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ).marginOnly(top: 30),
                            Container(
                              height: 246.h,
                              width: 1000.w,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                  image: AssetImage('assets/sc_24/lifetime_bg.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 124.h,
                                    width: 451.w,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image:
                                        AssetImage('assets/sc_24/lifetime.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ).marginOnly(left: 70.w),
                                  Spacer(),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "\$ 9999",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 60.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ).marginOnly(right: 70.w, left: 100.w),
                                      Positioned(
                                        bottom: -7.h,
                                        right: 50.w,
                                        child: Container(
                                          height: 82.h,
                                          width: 282.w,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/sc_24/bestoffer.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -40.h, // Adjust as needed
                      left: 0,
                      right: 0, // Center horizontally
                      child: Align(
                        alignment: Alignment.topCenter, // Center it horizontally
                        child: Container(
                          height: 82.h,
                          width: 269.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: AssetImage('assets/sc_24/plans.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).marginOnly(top: 50.h),
                Spacer(),
                Center(
                  child: BIG_PressUnpress(
                    onTap: () {

                    },
                    height: 160.h,
                    width: 1040.w,
                    imageAssetPress: 'assets/sc_24/upgrade_unpress.png',
                    imageAssetUnPress: 'assets/sc_24/upgrade_unpress.png',
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Terms of use",
                        style: TextStyle(color: Color(0XFF464646), fontSize: 45.sp),
                      ),
                      Container(
                        height: 40.h,
                        width: 3.w,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(color: Color(0XFF464646), fontSize: 45.sp),
                      ),
                      Container(
                        height: 40.h,
                        width: 3.w,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: (){
                          print("xxxxx");
                          Future.delayed(const Duration(seconds: 2), () {
                            BIG_CreditsManager.getUserCredits().then((credits) {
                              // print(credits);
                              if (credits == 0) {
                                Fluttertoast.showToast(
                                    msg: 'Your plan not found!',
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white);
                                AdsVariable.isPurchase = false;
                              } else if (credits > 0) {
                                BIG_SharedPreferencesService.setCreditValue(credits, 'Credit');
                                Fluttertoast.showToast(
                                  msg: 'Your plan restore successfully',
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                );
                              }
                              Navigator.pop(context);
                            });
                          });
                        },
                        child: Text(
                          "Restore",
                          style: TextStyle(color: Color(0XFF464646), fontSize: 45.sp),
                        ),
                      )
                    ],
                  ),
                ).marginOnly(bottom: 40.h),
              ],
            ),
          ),
        ),
      );
    }
    else{
      return  Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          height: 2208.h,
          width: 1242.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sc_6/bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 980.h,
                    width: 1242.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/sc_24/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                      right: 30.w,
                      top: 50.h,
                      child: GestureDetector(
                        onTap: (){
                          if(widget.home == true){
                            AdsLoadUtil.showInterstitial(onDismissed: () {
                              Get.back();
                            });
                          }else{
                            AdsLoadUtil.showInterstitial(onDismissed: () {
                              Get.to(() => BIG_Homepage());
                            });
                          }
                        },
                        child:close == true ?  Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40.h,
                                width: 40.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage('assets/sc_24/cancel_unpress.png'))
                                ),
                              ),
                            )
                        ): SizedBox.shrink(),
                      )),
                  Positioned(
                    bottom: 120.h,
                    left: 100.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 52.h,
                          width: 563.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              AssetImage('assets/sc_24/fast processing.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ).marginOnly(right: 50.w),
                        Container(
                          height: 51.h,
                          width: 443.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/sc_24/unlock pro.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 40.h,
                    left: 360.w,
                    child: Center(
                      child: Container(
                        height: 52.h,
                        width: 610.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/sc_24/ads.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ).marginOnly(bottom: 150.h),
              Stack(
                clipBehavior: Clip.none, // Prevent clipping
                children: [
                  Center(
                    child: Container(
                      height: 720.h,
                      width: 1118.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/sc_24/plans_box.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectimageindex = 1;
                                  });
                                },
                                child: Container(
                                  height: 300.h,
                                  width: 480.w,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: AssetImage(selectimageindex == 1
                                          ? 'assets/sc_24/button_unpress_bg-1.png'
                                          : 'assets/sc_24/button_unpress_bg.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "100 Credit",
                                        style: TextStyle(color: Colors.white),
                                      ).marginOnly(bottom: 10.h),
                                      Container(
                                        height: 3.h,
                                        width: 243.w,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/sc_24/divider.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$ 99',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 80.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Pay for weekly base",
                                        style: TextStyle(
                                            color: Color(0xFF464646),
                                            fontSize: 35.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectimageindex = 2;
                                  });
                                },
                                child: Container(
                                  height: 300.h,
                                  width: 480.w,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      image: AssetImage(selectimageindex == 2
                                          ? 'assets/sc_24/button_unpress_bg-1.png'
                                          : 'assets/sc_24/button_unpress_bg.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "1000 Credit",
                                        style: TextStyle(color: Colors.white),
                                      ).marginOnly(bottom: 10.h),
                                      Container(
                                        height: 3.h,
                                        width: 243.w,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/sc_24/divider.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$ 999',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 80.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Pay for Monthly base",
                                        style: TextStyle(
                                            color: Color(0xFF464646),
                                            fontSize: 35.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ).marginOnly(top: 30),
                          // Container(
                          //   height: 246.h,
                          //   width: 1000.w,
                          //   decoration: BoxDecoration(
                          //     color: Colors.black,
                          //     image: DecorationImage(
                          //       image: AssetImage('assets/sc_24/lifetime_bg.png'),
                          //       fit: BoxFit.contain,
                          //     ),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //         height: 124.h,
                          //         width: 451.w,
                          //         decoration: BoxDecoration(
                          //           color: Colors.black,
                          //           image: DecorationImage(
                          //             image:
                          //             AssetImage('assets/sc_24/lifetime.png'),
                          //             fit: BoxFit.contain,
                          //           ),
                          //         ),
                          //       ).marginOnly(left: 70.w),
                          //       Spacer(),
                          //       Stack(
                          //         children: [
                          //           SizedBox(
                          //             width: 100,
                          //           ),
                          //           Column(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: [
                          //               Text(
                          //                 "\$ 9999",
                          //                 style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontSize: 60.sp,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ],
                          //           ).marginOnly(right: 70.w, left: 100.w),
                          //           Positioned(
                          //             bottom: -7.h,
                          //             right: 50.w,
                          //             child: Container(
                          //               height: 82.h,
                          //               width: 282.w,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.black,
                          //                 image: DecorationImage(
                          //                   image: AssetImage(
                          //                       'assets/sc_24/bestoffer.png'),
                          //                   fit: BoxFit.contain,
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40.h, // Adjust as needed
                    left: 0,
                    right: 0, // Center horizontally
                    child: Align(
                      alignment: Alignment.topCenter, // Center it horizontally
                      child: Container(
                        height: 82.h,
                        width: 269.w,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: AssetImage('assets/sc_24/plans.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Center(
                child: BIG_PressUnpress(
                  onTap: () async {
                    BIG_DialogService.showLoading(context);
                    try {
                      final customerInfo =
                      await Purchases.purchasePackage(selectedPackage!);
                      appData.entitlementIsActive = customerInfo
                          .entitlements.all[entitlementKey]!.isActive;
                      CheckPurchasesStatus.initPlatformState()
                          .then((value) {
                        if (value) {
                          Fluttertoast.showToast(
                              msg: 'Your plan subscribe successfully',
                              backgroundColor: const Color(0xfff94952),
                              textColor: Colors.white);
                          // ignore: use_build_context_synchronously
                          if (widget.item) {
                            Get.back();
                            // Navigator.pop(context, true);
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return BIG_Homepage();
                                  }),
                                  (route) => false,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'Filed');
                        }
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } on PlatformException catch (e) {
                      Navigator.pop(context);
                      final errorCode =
                      PurchasesErrorHelper.getErrorCode(e);
                      if (errorCode ==
                          PurchasesErrorCode.purchaseCancelledError) {
                        if (kDebugMode) {
                          print('User cancelled');
                        }
                      } else if (errorCode ==
                          PurchasesErrorCode.purchaseNotAllowedError) {
                        if (kDebugMode) {
                          print('User not allowed to purchase');
                        }
                      } else if (errorCode ==
                          PurchasesErrorCode.paymentPendingError) {
                        if (kDebugMode) {
                          print('Payment is pending');
                        }
                      }
                    }
                    //AdsVariable.isPurchase = true;
                    if (widget.item) {
                      Get.back();
                      // Navigator.of(context).pop(true);
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return BIG_Homepage();
                        }),
                            (route) => false,
                      );
                    }
                  },
                  height: 160.h,
                  width: 1040.w,
                  imageAssetPress: 'assets/sc_24/upgrade_unpress.png',
                  imageAssetUnPress: 'assets/sc_24/upgrade_unpress.png',
                ),
              ).marginOnly(bottom: 30.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.to(()=> BIG_TermsOfUse());
                      },
                      child: Text(
                        "Terms of use",
                        style: TextStyle(color: Color(0XFF464646), fontSize: 45.sp),
                      ),
                    ),
                    Container(
                      height: 40.h,
                      width: 3.w,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=> BIG_PrivacyPolicy());
                      },
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(color: Color(0XFF464646), fontSize: 45.sp),
                      ),
                    ),
                    Container(
                      height: 40.h,
                      width: 3.w,
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: (){
                        Future.delayed(const Duration(seconds: 1), () {
                          BIG_CreditsManager.getUserCredits().then((credits) {
                            // print(credits);
                            if (credits == 0) {
                              Fluttertoast.showToast(
                                  msg: 'Your plan not found!',
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white);
                               AdsVariable.isPurchase = false;
                            } else if (credits > 0) {
                              BIG_SharedPreferencesService.setCreditValue(credits, 'Credit');
                              Fluttertoast.showToast(
                                msg: 'Your plan restore successfully',
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                              );
                              Navigator.pop(context);
                            }
                            // Navigator.pop(context);
                          });
                        });

                      },
                      child: Text(
                        "Restore",
                        style: TextStyle(color: Color(0XFF464646), fontSize: 45.sp),
                      ),
                    )
                  ],
                ),
              ).marginOnly(bottom: 40.h),
            ],
          ),
        ),
      );}
  }

}
