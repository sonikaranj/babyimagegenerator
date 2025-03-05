import 'dart:async';
import 'package:babyimage/pages/BIG_Homepage.dart';
import 'package:babyimage/pages/Setting/BIG_privacy_policy.dart';
import 'package:babyimage/pages/Setting/BIG_TernsOfUse.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../Ads/app_open_ad.dart';
import '../Ads/life_cycle.dart';
import '../services/BIG_Dialog.dart';
import 'constant.dart';
import 'initPlatformState.dart';

class UpsellScreen extends StatefulWidget {
  final bool item;

  const UpsellScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpsellScreenState();
}

class _UpsellScreenState extends State<UpsellScreen> {
  Offerings? _offerings;
  bool week = false;
  bool onemonth = true;
  bool threeweek = false;
  bool isClose = false;
  Map<String, Package>? availablePackages;
  Map<String, Package>? packageEntry;
  Package? selectedPackage;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late AppLifecycleReactor _appLifecycleReactor;
  // CreditManager creditManager = CreditManager();

  //NativeAdService nativeAdService = Get.put(NativeAdService());

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if (_offerings != null) {
      final offering = _offerings!.current;
      if (offering != null) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            child: Container(
              height: 2208.h,
              width: 1242.w,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/sc_6/bg.png'),
                      fit: BoxFit.cover)),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.only(top: 60.h, bottom: 20.h, left: 40.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: isClose
                              ? BIG_PressUnpress(
                            height: 125.h,
                            width: 125.h,
                            imageAssetUnPress:
                            'assets/premium/close_btn_unpress.png',
                            imageAssetPress:
                            'assets/premium/close_btn_press.png',
                            onTap: () {
                              if (widget.item) {
                                Navigator.pop(context);
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
                            },
                          )
                              : SizedBox(
                            height: 125.h,
                            width: 125.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 162.h,
                    width: 357.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/premium/pro_bg.png'),
                        )),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30.w,
                        ),
                        Image(
                          image: AssetImage('assets/premium/pro_ic.png'),
                          height: 98.h,
                          width: 98.w,
                        ),
                        SizedBox(width: 30.w),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            "PRO",
                            style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 65.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 378.h,
                    width: 928.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/premium/app_name_bg.png'))),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Image(
                        height: 232.h,
                        width: 700.w,
                        image: AssetImage('assets/premium/text_1.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/premium/layer_ic.png'),
                        height: 85.h,
                        width: 85.w,
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      Text(
                        "Access to all layers",
                        style: TextStyle(color: Colors.white, fontSize: 45.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/premium/loc_ic.png'),
                        height: 85.h,
                        width: 95.w,
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      Text(
                        "Access to street view",
                        style: TextStyle(color: Colors.white, fontSize: 45.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/premium/ads_ic.png'),
                        height: 85.h,
                        width: 85.w,
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      Text(
                        "Ads Free Experience",
                        style: TextStyle(color: Colors.white, fontSize: 45.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  SizedBox(
                    height: 650.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: (availablePackages?.entries ?? [])
                          .take(3)
                          .map((packageEntry) {
                        print(
                            '${packageEntry.value.storeProduct.subscriptionPeriod}__------------------------------------------');
                        return InkWell(
                          onTap: () {
                            setState(() {
                              week = false;
                              onemonth = false;
                              threeweek = false;
                              selectedPackage = packageEntry.value;
                            });
                          },
                          child: Container(
                            height: 375.h,
                            width: 300.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      selectedPackage == packageEntry.value
                                          ? "assets/premium/select_plan_bg.png"
                                          : "assets/premium/plan_bg.png")),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 60.h),
                                  child: Text(
                                    (packageEntry.value.storeProduct
                                        .subscriptionPeriod ??
                                        "") ==
                                        'P1W'
                                        ? '1 Week'
                                        : (packageEntry.value.storeProduct
                                        .subscriptionPeriod ??
                                        "") ==
                                        'P1M'
                                        ? '1 Month'
                                        : "Life Time ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: selectedPackage == packageEntry.value
                                          ? Colors.white
                                          : const Color(0xffC0C1C5),
                                      fontSize: 45.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60.h,
                                ),
                                Text(
                                  packageEntry.value.storeProduct.priceString,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 50.sp,
                                      color: selectedPackage == packageEntry.value
                                          ? Colors.black
                                          : const Color(0xffC0C1C5)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  InkWell(
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
                                backgroundColor: const Color(0xFF14e7e2),
                                textColor: Colors.white);
                            // ignore: use_build_context_synchronously
                            if (widget.item) {
                              Navigator.pop(context, true);
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
                        Navigator.of(context).pop(true);
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
                    child: Container(
                      height: 170.h,
                      width: 1015.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                              AssetImage('assets/premium/continue_gif.gif'))),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 60.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60.h, right: 60.h),
                    child: SizedBox(
                      height: 60.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BIG_TermsOfUse(),
                                    ));
                              },
                              child: Container(
                                width: 265.w,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  "Terms of use",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 35.sp,
                                      color: Colors.white),
                                ),
                              )),
                          Image(
                            image: AssetImage('assets/premium/circle.png'),
                            height: 15.h,
                            width: 15.w,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BIG_PrivacyPolicy(),
                                    ));
                              },
                              child: Container(
                                width: 265.w,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  "Privacy policy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 35.sp,
                                      color: Colors.white),
                                ),
                              )),
                          Image(
                            image: AssetImage('assets/premium/circle.png'),
                            height: 15.h,
                            width: 15.w,
                          ),
                          InkWell(
                              onTap: () async {
                                BIG_DialogService.showLoading(context);
                                try {
                                  final customerInfo =
                                  await Purchases.restorePurchases();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  bool isActive = customerInfo.entitlements
                                      .all[entitlementKey]?.isActive ??
                                      false;
                                  if (kDebugMode) {
                                    print('isActive: $isActive');
                                  }
                                  if (!isActive) {
                                    // ignore: use_build_context_synchronously
                                    BIG_DialogService.restorePurchasesDialog(context);
                                  }
                                } catch (e) {
                                  print('Exception during restore: $e');
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                width: 265.w,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  "Restore",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 35.sp,
                                      color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Container(
          height: 2208.h,
          width: 1242.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/sc_6/bg.png'),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 60.h, bottom: 20.h, left: 40.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: isClose
                          ? BIG_PressUnpress(
                              height: 40.h,
                              width: 40.h,
                              imageAssetUnPress:
                                  'assets/sc_24/cancel_unpress.png',
                              imageAssetPress:
                                  'assets/sc_24/cancel_press.png',
                              onTap: () {
                                if (widget.item) {
                                  Navigator.pop(context);
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
                              },
                            )
                          : SizedBox(
                              height: 125.h,
                              width: 125.h,
                            ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 162.h,
                width: 357.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/premium/pro_bg.png'),
                )),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30.w,
                    ),
                    Image(
                      image: AssetImage('assets/premium/pro_ic.png'),
                      height: 98.h,
                      width: 98.w,
                    ),
                    SizedBox(width: 30.w),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        "PRO",
                        style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 65.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 378.h,
                width: 928.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/premium/app_name_bg.png'))),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Image(
                    height: 232.h,
                    width: 700.w,
                    image: AssetImage('assets/premium/text_1.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/premium/layer_ic.png'),
                    height: 85.h,
                    width: 85.w,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Text(
                    "Access to all layers",
                    style: TextStyle(color: Colors.white, fontSize: 45.sp),
                  )
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/premium/loc_ic.png'),
                    height: 85.h,
                    width: 95.w,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Text(
                    "Access to street view",
                    style: TextStyle(color: Colors.white, fontSize: 45.sp),
                  )
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/premium/ads_ic.png'),
                    height: 85.h,
                    width: 85.w,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  Text(
                    "Ads Free Experience",
                    style: TextStyle(color: Colors.white, fontSize: 45.sp),
                  )
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              SizedBox(
                height: 650.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: (availablePackages?.entries ?? [])
                      .take(3)
                      .map((packageEntry) {
                    print(
                        '${packageEntry.value.storeProduct.subscriptionPeriod}__------------------------------------------');
                    return InkWell(
                      onTap: () {
                        setState(() {
                          week = false;
                          onemonth = false;
                          threeweek = false;
                          selectedPackage = packageEntry.value;
                        });
                      },
                      child: Container(
                        height: 375.h,
                        width: 300.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  selectedPackage == packageEntry.value
                                      ? "assets/premium/select_plan_bg.png"
                                      : "assets/premium/plan_bg.png")),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 60.h),
                              child: Text(
                                (packageEntry.value.storeProduct
                                                .subscriptionPeriod ??
                                            "") ==
                                        'P1W'
                                    ? '1 Week'
                                    : (packageEntry.value.storeProduct
                                                    .subscriptionPeriod ??
                                                "") ==
                                            'P1M'
                                        ? '1 Month'
                                        : "Life Time ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: selectedPackage == packageEntry.value
                                      ? Colors.white
                                      : const Color(0xffC0C1C5),
                                  fontSize: 45.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60.h,
                            ),
                            Text(
                              packageEntry.value.storeProduct.priceString,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 50.sp,
                                  color: selectedPackage == packageEntry.value
                                      ? Colors.black
                                      : const Color(0xffC0C1C5)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              InkWell(
                onTap: () async {
                  // DialogService.showLoading(context);
                  // try {
                  //   final customerInfo =
                  //       await Purchases.purchasePackage(selectedPackage!);
                  //   appData.entitlementIsActive = customerInfo
                  //       .entitlements.all[entitlementKey]!.isActive;
                  //   CheckPurchasesStatus.initPlatformState()
                  //       .then((value) {
                  //     if (value) {
                  //       Fluttertoast.showToast(
                  //           msg: 'Your plan subscribe successfully',
                  //           backgroundColor: const Color(0xfff94952),
                  //           textColor: Colors.white);
                  //       // ignore: use_build_context_synchronously
                  //       if (widget.item) {
                  //         Navigator.pop(context, true);
                  //       } else {
                  //         Navigator.pushAndRemoveUntil(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (BuildContext context) {
                  //                 return StreetView(
                  //                     latitude: latitude!,
                  //                     longitude: longitude!);
                  //               }),
                  //               (route) => false,
                  //         );
                  //       }
                  //     } else {
                  //       Fluttertoast.showToast(msg: 'Filed');
                  //     }
                  //   });
                  //   // ignore: use_build_context_synchronously
                  //   Navigator.pop(context);
                  // } on PlatformException catch (e) {
                  //   Navigator.pop(context);
                  //   final errorCode =
                  //   PurchasesErrorHelper.getErrorCode(e);
                  //   if (errorCode ==
                  //       PurchasesErrorCode.purchaseCancelledError) {
                  //     if (kDebugMode) {
                  //       print('User cancelled');
                  //     }
                  //   } else if (errorCode ==
                  //       PurchasesErrorCode.purchaseNotAllowedError) {
                  //     if (kDebugMode) {
                  //       print('User not allowed to purchase');
                  //     }
                  //   } else if (errorCode ==
                  //       PurchasesErrorCode.paymentPendingError) {
                  //     if (kDebugMode) {
                  //       print('Payment is pending');
                  //     }
                  //   }
                  // }
                },
                child: Container(
                  height: 170.h,
                  width: 1015.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/premium/continue_gif.gif'))),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 60.h, right: 60.h),
                child: SizedBox(
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BIG_TermsOfUse(),
                                ));
                          },
                          child: Container(
                            width: 265.w,
                            child: Text(
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              "Terms of use",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35.sp,
                                  color: Colors.white),
                            ),
                          )),
                      Image(
                        image: AssetImage('assets/premium/circle.png'),
                        height: 15.h,
                        width: 15.w,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BIG_PrivacyPolicy(),
                                ));
                          },
                          child: Container(
                            width: 265.w,
                            child: Text(
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              "Privacy policy",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35.sp,
                                  color: Colors.white),
                            ),
                          )),
                      Image(
                        image: AssetImage('assets/premium/circle.png'),
                        height: 15.h,
                        width: 15.w,
                      ),
                      InkWell(
                          onTap: () async {
                            BIG_DialogService.showLoading(context);
                            try {
                              final customerInfo =
                                  await Purchases.restorePurchases();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              bool isActive = customerInfo.entitlements
                                      .all[entitlementKey]?.isActive ??
                                  false;
                              if (kDebugMode) {
                                print('isActive: $isActive');
                              }
                              if (!isActive) {
                                // ignore: use_build_context_synchronously
                                BIG_DialogService.restorePurchasesDialog(context);
                              }
                            } catch (e) {
                              print('Exception during restore: $e');
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            width: 265.w,
                            child: Text(
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              "Restore",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 35.sp,
                                  color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );

    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

// ignore: camel_case_types
class sizeWidget extends StatelessWidget {
  const sizeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.h,
    );
  }
}

// class _PurchaseButton extends StatelessWidget {
//   final Package package;
//
//   // ignore: public_member_api_docs
//   const _PurchaseButton({Key? key, required this.package}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => ElevatedButton(
//         onPressed: () async {
//           try {
//             final customerInfo = await Purchases.purchasePackage(package);
//             final isPro = customerInfo.entitlements.active.containsKey(entitlementKey);
//             if (isPro) {
//               // ignore: use_build_context_synchronously
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CatsScreen()),
//               );
//             }
//           } on PlatformException catch (e) {
//             final errorCode = PurchasesErrorHelper.getErrorCode(e);
//             if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
//               print('User cancelled');
//             } else if (errorCode ==
//                 PurchasesErrorCode.purchaseNotAllowedError) {
//               print('User not allowed to purchase');
//             } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
//               print('Payment is pending');
//             }
//           }
//         },
//         child: Text('Buy Package: ${package.storeProduct.subscriptionPeriod ?? package.storeProduct.title}\n${package.storeProduct.priceString}'),
//       );
// }

// class _PurchaseStoreProductButton extends StatelessWidget {
//   final StoreProduct storeProduct;
//
//   // ignore: public_member_api_docs
//   const _PurchaseStoreProductButton({Key? key, required this.storeProduct})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => ElevatedButton(
//         onPressed: () async {
//           try {
//             final customerInfo = await Purchases.purchaseStoreProduct(storeProduct);
//             final isPro = customerInfo.entitlements.active.containsKey(entitlementKey);
//             if (isPro) {
//               // ignore: use_build_context_synchronously
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CatsScreen()),
//               );
//             }
//           } on PlatformException catch (e) {
//             final errorCode = PurchasesErrorHelper.getErrorCode(e);
//             if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
//               print('User cancelled');
//             } else if (errorCode ==
//                 PurchasesErrorCode.purchaseNotAllowedError) {
//               print('User not allowed to purchase');
//             } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
//               print('Payment is pending');
//             }
//           }
//         },
//         child: Text(
//             'Buy StoreProduct (${storeProduct.productCategory}): ${storeProduct.subscriptionPeriod ?? storeProduct.title}\n${storeProduct.priceString}'),
//       );
// }

// class _PurchaseSubscriptionOptionButton extends StatelessWidget {
//   final SubscriptionOption option;
//
//   // ignore: public_member_api_docs
//   const _PurchaseSubscriptionOptionButton({Key? key, required this.option})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => ElevatedButton(
//         onPressed: () async {
//           try {
//             final customerInfo =
//                 await Purchases.purchaseSubscriptionOption(option);
//             final isPro =
//                 customerInfo.entitlements.active.containsKey(entitlementKey);
//             if (isPro) {
//               // ignore: use_build_context_synchronously
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CatsScreen()),
//               );
//             }
//           } on PlatformException catch (e) {
//             final errorCode = PurchasesErrorHelper.getErrorCode(e);
//             if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
//               print('User cancelled');
//             } else if (errorCode ==
//                 PurchasesErrorCode.purchaseNotAllowedError) {
//               print('User not allowed to purchase');
//             } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
//               print('Payment is pending');
//             }
//           }
//         },
//         child:
//             Text('Buy Option: - (${option.id}\n${option.pricingPhases.map((e) {
//           return '${e.price.formatted} for ${e.billingPeriod?.value} ${e.billingPeriod?.unit}';
//         }).join(' -> ')})'),
//       );
// }

// // ignore: public_member_api_docs
// class CatsScreen extends StatelessWidget {
//   const CatsScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(title: const Text('Cats Screen')),
//         body: Center(
//             child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('User is pro'),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final customerInfo = await Purchases.getCustomerInfo();
//                   final refundStatus =
//                       await Purchases.beginRefundRequestForEntitlement(
//                           customerInfo.entitlements.active[entitlementKey]!);
//                   print('Refund request successful with status: $refundStatus');
//                 } catch (e) {
//                   print('Refund request exception: $e');
//                 }
//               },
//               child: const Text('Begin refund for pro entitlement'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // In order to defer in-app messages so they're only shown when this button is pressed, you must configure
//                 // the SDK with `configuration.shouldShowInAppMessagesAutomatically = false;`
//                 Purchases.showInAppMessages(types: {
//                   InAppMessageType.billingIssue,
//                   InAppMessageType.priceIncreaseConsent,
//                   InAppMessageType.generic
//                 });
//               },
//               child: const Text('Show In-App Messages'),
//             ),
//           ],
//         )),
//       );
// }

class AppData {
  static final AppData _appData = AppData._internal();

  bool entitlementIsActive = false;
  String appUserID = '';

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
