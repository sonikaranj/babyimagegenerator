import 'dart:async';
import 'package:babyimage/pages/Setting/BIG_SubmitRating.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../services/BIG_Dialog.dart';
import '../../Inapppurchase/credit/BIG_InappPurchase.dart';
import 'BIG_checkConnectivity.dart';
import 'BIG_privacy_policy.dart';

class BIG_SettingScreen extends StatefulWidget {
  @override
  State<BIG_SettingScreen> createState() => _BIG_SettingScreenState();
}

class _BIG_SettingScreenState extends State<BIG_SettingScreen> {
  // final String data;
  BIG_SubmitRating submitRating = BIG_SubmitRating();

  bool isShare = false;
  bool _issharePressed = false;
  bool _isratePressed = false;
  bool _isprivacyPressed = false;
  bool _isgdprPressed = false;


  // final InitializationHelper _initializationHelper = InitializationHelper();
  void _handleshareTap(bool isPressed) {
    setState(() {
      _issharePressed = isPressed;
    });
  }

  void _resetshareTap() {
    _handleshareTap(false);
  }
  void _handlerateTap(bool isPressed) {
    setState(() {
      _isratePressed = isPressed;
    });
  }

  void _resetrateTap() {
    _handlerateTap(false);
  }
  void _handleprivacyTap(bool isPressed) {
    setState(() {
      _isprivacyPressed = isPressed;
    });
  }

  void _resestprivacyTap() {
    _handleprivacyTap(false);
  }
 void _handlegdprTap(bool isPressed) {
    setState(() {
      _isgdprPressed = isPressed;
    });
  }

  void _resestgdprTap() {
    _handlegdprTap(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Setting",
            style: TextStyle(
                color: Colors.white, fontSize: 50.sp, fontFamily: "regular"),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(15),
            child: BIG_PressUnpress(
              imageAssetUnPress: 'assets/sc_6/back_press.png',
              imageAssetPress: 'assets/sc_6/back_press.png',
              onTap: () {
                Navigator.pop(context);
              },
              height: 70.h,
              width: 70.w,
              child: null,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                BIG_PressUnpress(onTap: () {
                  Get.to(() => BIG_Inapppurchase(item: true,home: true) );
                },
                  height: 177.h,
                  width: 1000.w,
                  imageAssetPress: 'assets/sc_23/pro_unpress-1.png',
                  imageAssetUnPress: 'assets/sc_23/pro_unpress.png',).marginOnly(bottom: 20.h),
                80.verticalSpace,
                GestureDetector(
                  onTapDown: (_) => _handleshareTap(true),
                  onTapUp: (_) => _handleshareTap(false),
                  onTapCancel: _resetshareTap,
                  child: BIG_PressUnpress(
                    imageAssetUnPress:
                        "lib/asset/SettingScreen/share_app_pressed.png",
                    imageAssetPress:
                        "lib/asset/SettingScreen/share_app_unpressed.png",
                    onTap: () {
                      BIG_ConnectivityService.checkConnectivity().then((value) {
                        if (value) {
                          if (!isShare) {
                            isShare = true;
                            submitRating.shareContent(context);
                            Future.delayed(const Duration(seconds: 2), () {
                              isShare = false;
                            });
                          }
                        } else {
                          BIG_DialogService.showCheckConnectivity(context);
                        }
                      });
                    },
                    height: 160.h,
                    width: 920.w,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.h, left: 200.w),
                          child: Text("Share App",
                              style: TextStyle(
                                  color: _issharePressed?Colors.white:Color(0xff979797), fontFamily: "regular")),
                        )),
                  ),
                ),
                20.verticalSpace,
                GestureDetector(
                  onTapDown: (_) => _handlerateTap(true),
                  onTapUp: (_) => _handlerateTap(false),
                  onTapCancel: _resetrateTap,
                  child: BIG_PressUnpress(
                    imageAssetUnPress:
                        'lib/asset/SettingScreen/rate_app_unpressed.png',
                    imageAssetPress:
                        'lib/asset/SettingScreen/rate_app_pressed.png',
                    onTap: () {
                      BIG_ConnectivityService.checkConnectivity().then((value) {
                        if (value) {
                          submitRating.submitRating(context);
                        } else {
                          BIG_DialogService.showCheckConnectivity(context);
                        }
                      });
                    },
                    height: 160.h,
                    width: 920.w,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.h, left: 200.w),
                          child: Text("Rate App",
                              style: TextStyle(
                                  color: _isratePressed?Colors.white:Color(0xff979797), fontFamily: "regular")),
                        )),
                  ),
                ),
                20.verticalSpace,
                GestureDetector(
                  onTapDown: (_) => _handleprivacyTap(true),
                  onTapUp: (_) => _handleprivacyTap(false),
                  onTapCancel: _resestprivacyTap,
                  child: BIG_PressUnpress(
                    imageAssetUnPress:
                        'lib/asset/SettingScreen/privacy policy_pressed.png',
                    imageAssetPress:
                        'lib/asset/SettingScreen/privacy policy_unpressed.png',
                    onTap: () {
                      BIG_ConnectivityService.checkConnectivity().then((value) {
                        if (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BIG_PrivacyPolicy()));
                        } else {
                          BIG_DialogService.showCheckConnectivity(context);
                        }
                      });
                    },
                    height: 160.h,
                    width: 920.w,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.h, left: 200.w),
                          child: Text("Privacy Policy",
                              style: TextStyle(
                                  color: _isprivacyPressed?Colors.white:Color(0xff979797), fontFamily: "regular")),
                        )),
                  ),
                ),
                20.verticalSpace,
                GestureDetector(
                  onTapDown: (_) => _handlegdprTap(true),
                  onTapUp: (_) => _handlegdprTap(false),
                  onTapCancel: _resestgdprTap,
                  child: BIG_PressUnpress(
                    imageAssetUnPress:
                        'lib/asset/SettingScreen/gdpr_pressed-1.png',
                    imageAssetPress: 'lib/asset/SettingScreen/gdpr_pressed.png',
                    // onTap: () async {
                    //   final didChangePreferences = await _initializationHelper.changePrivacyPreferences();
                    //   Fluttertoast.showToast(msg: didChangePreferences ? 'Your privacy choices have been updated' : 'An error occurred while trying to change your privacy choices',backgroundColor: backgroundColor,textColor: textColor);
                    // },
                    height: 160.h,
                    width: 920.w,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.h, left: 200.w),
                          child: Text("GDPR",
                              style: TextStyle(
                                  color: _isgdprPressed?Colors.white:Color(0xff979797), fontFamily: "regular")),
                        )),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
