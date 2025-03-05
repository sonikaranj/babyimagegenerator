import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shimmer/shimmer.dart';

class AICAP_UpsellScreen extends StatefulWidget {
  final bool item;

  const AICAP_UpsellScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AICAP_UpsellScreenState();
}

class _AICAP_UpsellScreenState extends State<AICAP_UpsellScreen> {
  Offerings? _offerings;

  // bool week = true;
  // bool onemonth = false;
  // bool threeweek = false;
  bool isClose = false;
  Map<String, Package>? availablePackages;
  Map<String, Package>? packageEntry;
  Package? selectedPackage;

  @override
  void initState() {
    super.initState();
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
        //printJson(offerings.toJson());
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
    if (kDebugMode) {
      print(offerings);
    }
  }

  void printJson(Map<String, dynamic>? json, [int indentation = 0]) {
    json?.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        //printJson(value, indentation + 2);
      }
    });
  }

  back() {
    // AICAP_InterstitialAdManager.showInterstitial(
    //   const AICAP_HomeScreen(),
    //   widget.item ? 'pop' : 'pushAndRemoveUntil',
    //   AICAP_AdsVariable.fullscreen_in_app_screen,
    //   AICAP_AdsVariable.in_app_screen_ad_continue_ads_online,
    //   AICAP_AdsVariable.inAppFlag,
    //   context,
    // );
    // AICAP_AdsVariable.inAppFlag++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: isClose
            ? IconButton(
                onPressed: () {
                  back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white24,
                ),
              )
            : const SizedBox.shrink(),
      ),
      body: WillPopScope(
        onWillPop: () {
          back();
          return Future(() => false);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/premium_screen/logo.png',
              width: 979.w,
              height: 819.h,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/premium_screen/features_star.png',
                  width: 46.w,
                  height: 46.w,
                ),
                20.horizontalSpace,
                Text(
                  'Unlock Premium Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontFamily: 'Medium',
                  ),
                ),
                40.horizontalSpace,
                Image.asset(
                  'assets/premium_screen/features_star.png',
                  width: 46.w,
                  height: 46.w,
                ),
                20.horizontalSpace,
                Text(
                  'Get Unlimited Access',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontFamily: 'Medium',
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/premium_screen/features_star.png',
                  width: 46.w,
                  height: 46.w,
                ),
                20.horizontalSpace,
                Text(
                  'Ad-Free Experience',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontFamily: 'Medium',
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/premium_screen/features_star.png',
                  width: 46.w,
                  height: 46.w,
                ),
                20.horizontalSpace,
                Text(
                  '20 Credits Free',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.sp,
                    fontFamily: 'Medium',
                  ),
                ),
              ],
            ),
            50.verticalSpace,
            _offerings != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: availablePackages!.entries.take(2).map(
                      (packageEntry) {
                        print(packageEntry.value.storeProduct.identifier);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPackage = packageEntry.value;
                            });
                          },
                          child: Container(
                            height: selectedPackage == packageEntry.value
                                ? 268.h
                                : 199.h,
                            width: selectedPackage == packageEntry.value
                                ? 1098.w
                                : 1119.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  selectedPackage == packageEntry.value
                                      ? 'assets/premium_screen/weekly_monthly_press_box.png'
                                      : 'assets/premium_screen/weekly_monthly_unpress_box.png',
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                50.horizontalSpace,
                                Image.asset(
                                  selectedPackage == packageEntry.value
                                      ? 'assets/premium_screen/select.png'
                                      : 'assets/premium_screen/unselect.png',
                                  width: 64.w,
                                  height: 64.w,
                                ),
                                70.horizontalSpace,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      packageEntry.value.storeProduct
                                                  .identifier ==
                                              'ds.aivideocap.com.oneweek'
                                          ? 'Weekly'
                                          : 'Monthly',
                                      style: TextStyle(
                                        color: selectedPackage ==
                                                packageEntry.value
                                            ? Colors.white
                                            : const Color(0xff807f7f),
                                        fontFamily: 'Medium',
                                        fontSize: 50.sp,
                                      ),
                                    ),
                                    if (selectedPackage == packageEntry.value)
                                      Text(
                                        packageEntry.value.storeProduct
                                                    .identifier ==
                                                'ds.aivideocap.com.oneweek'
                                            ? 'Pay for one week'
                                            : 'Pay for one month',
                                        style: TextStyle(
                                          color: const Color(0xff807f7f),
                                          fontFamily: 'Medium',
                                          fontSize: 40.sp,
                                        ),
                                      ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  width: 320.w,
                                  height: 112.h,
                                  decoration:
                                      selectedPackage == packageEntry.value
                                          ? const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/premium_screen/press_amount_bg.png'),
                                              ),
                                            )
                                          : null,
                                  child: Center(
                                    child: Text(
                                      packageEntry
                                          .value.storeProduct.priceString,
                                      style: TextStyle(
                                        color: selectedPackage ==
                                                packageEntry.value
                                            ? Colors.white
                                            : const Color(0xff807f7f),
                                        fontFamily: 'SemiBold',
                                        fontSize: 50.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                60.horizontalSpace,
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )
                : buildColumn(),
            30.verticalSpace,
            // buy_now_button(context),
            privacy_Terms_of_us_restore(context),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  // Future storeCredit() async {
  //   var credit = await AICAP_SharedPreferencesService.getCreditValue('Credit');
  //   credit += 20;
  //   AICAP_SharedPreferencesService.setCreditValue(credit, 'Credit');
  //   AICAP_CreditsManager().saveUserCredits(credit);
  // }

  // AICAP_PressUnpress buy_now_button(BuildContext context) {
  //   return AICAP_PressUnpress(
  //     onTap: () async {
  //       AICAP_DialogService.showLoading(context);
  //       try {
  //         final customerInfo =
  //             await Purchases.purchasePackage(selectedPackage!);
  //         appData.entitlementIsActive =
  //             customerInfo.entitlements.all[entitlementKey]!.isActive;
  //         AICAP_CheckPurchasesStatus.initPlatformState().then((value) {
  //           if (value) {
  //             Fluttertoast.showToast(
  //               msg: 'Your plan subscribe successfully',
  //               textColor: Colors.white,
  //               backgroundColor: appColor,
  //             );
  //             storeCredit();
  //             if (widget.item) {
  //               Navigator.pop(context, true);
  //             } else {
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (BuildContext context) {
  //                   return const AICAP_HomeScreen();
  //                 }),
  //                 (route) => false,
  //               );
  //             }
  //           } else {
  //             Fluttertoast.showToast(
  //               msg: 'Failed',
  //               textColor: Colors.white,
  //               backgroundColor: appColor,
  //             );
  //           }
  //         });
  //         // ignore: use_build_context_synchronously
  //         Navigator.pop(context);
  //       } on PlatformException catch (e) {
  //         // ignore: use_build_context_synchronously
  //         Navigator.pop(context);
  //         final errorCode = PurchasesErrorHelper.getErrorCode(e);
  //         if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
  //           if (kDebugMode) {
  //             print('User cancelled');
  //           }
  //         } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
  //           if (kDebugMode) {
  //             print('User not allowed to purchase');
  //           }
  //         } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
  //           if (kDebugMode) {
  //             print('Payment is pending');
  //           }
  //         }
  //       }
  //     },
  //     height: 196.h,
  //     width: 1093.w,
  //     imageAssetPress: 'assets/premium_screen/go_premium_press.png',
  //     imageAssetUnPress: 'assets/premium_screen/go_premium_unpress.png',
  //   );
  // }

  Row privacy_Terms_of_us_restore(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        20.horizontalSpace,
        TextButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const AICAP_TermsOfUse(),
            //     ));
          },
          child: Text(
            "Terms of use",
            style: TextStyle(
              color: const Color(0xFF595959),
              fontFamily: "Medium",
              fontSize: 40.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const AICAP_PrivacyPolicy(),
            //     ));
          },
          child: Text(
            "Privacy policy",
            style: TextStyle(
              color: const Color(0xFF595959),
              fontFamily: "Medium",
              fontSize: 40.sp,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            // AICAP_DialogService.showLoading(context);
            // try {
            //   final customerInfo = await Purchases.restorePurchases();
            //   // ignore: use_build_context_synchronously
            //   Navigator.pop(context);
            //   bool isActive =
            //       customerInfo.entitlements.all[entitlementKey]?.isActive ??
            //           false;
            //   if (kDebugMode) {
            //     print('isActive: $isActive');
            //   }
            //   if (!isActive) {
            //     // ignore: use_build_context_synchronously
            //     AICAP_DialogService.restorePurchasesDialog(context);
            //   }
            // } catch (e) {
            //   print('Exception during restore: $e');
            //   Navigator.pop(context);
            // }
          },
          child: Text(
            "Restore",
            style: TextStyle(
              color: const Color(0xFF595959),
              fontFamily: "Medium",
              fontSize: 40.sp,
            ),
          ),
        ),
        30.horizontalSpace,
      ],
    );
  }

  Row buildColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Shimmer.fromColors(
            child: Container(
              height: 268.h,
              width: 1098.w,
              decoration: BoxDecoration(
                color: const Color(0xff242424),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    50.w,
                  ),
                ),
                border: Border.all(
                  color: const Color(0xff3d3d3d),
                ),
              ),
            ),
            baseColor: const Color(0xff202020),
            highlightColor: Colors.black)
      ],
    );
  }

// InkWell buildInkWell(MapEntry<String, Package> packageEntry) {
//   return InkWell(
//     splashColor: Colors.transparent,
//     highlightColor: Colors.transparent,
//     onTap: () {
//       setState(() {
//         week = false;
//         onemonth = false;
//         threeweek = false;
//         selectedPackage = packageEntry.value;
//       });
//     },
//     child: Align(
//       alignment: Alignment.center,
//       child: Container(
//         height: 150.h,
//         width: 962.w,
//         padding: EdgeInsets.symmetric(horizontal: 50.w),
//         margin: EdgeInsets.symmetric(vertical: 20.w),
//         decoration: BoxDecoration(
//           color: const Color(0xff242424),
//           borderRadius: BorderRadius.circular(35.h),
//           border: Border.all(
//               color: selectedPackage == packageEntry.value
//                   ? appColor
//                   : const Color(0xff404040)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 7,
//                   backgroundColor: selectedPackage == packageEntry.value
//                       ? appColor
//                       : textColor,
//                 ),
//                 SizedBox(
//                   width: 40.w,
//                 ),
//                 Text(
//                   (packageEntry.value.identifier ?? "") ==
//                           'phawk.deepfakevideofaceswap.com.onefourtynine'
//                       ? '149 Credit'
//                       : "449 Credit",
//                   style: TextStyle(
//                       fontSize: 55.sp, color: CupertinoColors.white),
//                 ),
//               ],
//             ),
//             Text(
//               packageEntry.value.storeProduct.priceString,
//               style: TextStyle(fontSize: 55.sp, color: CupertinoColors.white),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}

// ignore: camel_case_types
class sizeWidget extends StatelessWidget {
  const sizeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
    );
  }
}

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
