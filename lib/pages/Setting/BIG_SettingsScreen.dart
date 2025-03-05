import 'package:babyimage/Inapppurchase/credit/BIG_InappPurchase.dart';
import 'package:babyimage/pages/Setting/BIG_privacy_policy.dart';
import 'package:babyimage/pages/Setting/BIG_SubmitRating.dart';
import 'package:babyimage/pages/Setting/BIG_TernsOfUse.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Ads/requesting_consent.dart';
import '../../services/BIG_Dialog.dart';
import 'BIG_checkConnectivity.dart'; // For launching URLs

class BIG_SettingsScreen extends StatefulWidget {
   String data;
   BIG_SettingsScreen({super.key,required this.data});

  @override
  State<BIG_SettingsScreen> createState() => _BIG_SettingsScreenState();
}

class _BIG_SettingsScreenState extends State<BIG_SettingsScreen> {
  final InitializationHelper _initializationHelper = InitializationHelper();
  // Function to launch a URL
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
    return Scaffold(
      backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Padding(
              padding: EdgeInsets.all(12),
              child: BIG_PressUnpress(
                onTap: () {
                  Get.back();
                },
                unPressColor: Colors.transparent,
                height: 100.h,
                width: 100.w,
                imageAssetPress: 'assets/sc_6/back_press.png',
                imageAssetUnPress: 'assets/sc_8/back_unpress.png',
              )),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title:  Text('Settings',style: TextStyle(color: Colors.white,fontSize: 60.sp),),
        ),
        body: Container(
          height: 2208.h,
          width: 1242.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sc_6/bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 150.h,),
                BIG_PressUnpress(onTap: () {
                  Get.to(() => BIG_Inapppurchase(item: true,home: true) );
                },
                  height: 177.h,
                  width: 1000.w,
                  imageAssetPress: 'assets/sc_23/pro_unpress-1.png',
                  imageAssetUnPress: 'assets/sc_23/pro_unpress.png',).marginOnly(bottom: 20.h),
                GestureDetector(
                  onTapDown: (_) => _handleshareTap(true),
                  onTapUp: (_) => _handleshareTap(false),
                  onTapCancel: _resetshareTap,
                  child: BIG_PressUnpress(
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
                    height: 177.h,
                    width: 1000.w,
                    imageAssetPress: 'assets/sc_23/share_press.png',
                    imageAssetUnPress: 'assets/sc_23/share_unpress.png',).marginOnly(bottom: 20.h),
                ),
                GestureDetector(
                  onTapDown: (_) => _handlerateTap(true),
                  onTapUp: (_) => _handlerateTap(false),
                  onTapCancel: _resetrateTap,
                  child: BIG_PressUnpress(
                    onTap: () {
                      BIG_ConnectivityService.checkConnectivity().then((value) {
                        if (value) {
                          submitRating.submitRating(context);
                        } else {
                          BIG_DialogService.showCheckConnectivity(context);
                        }
                      });
                    },
                    height: 177.h,
                    width: 1000.w,
                    imageAssetPress: 'assets/sc_23/rate_press.png',
                    imageAssetUnPress: 'assets/sc_23/rate_unpress.png',).marginOnly(bottom: 20.h),
                ),
                GestureDetector(
                  onTapDown: (_) => _handleprivacyTap(true),
                  onTapUp: (_) => _handleprivacyTap(false),
                  onTapCancel: _resestprivacyTap,
                  child: BIG_PressUnpress(
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
                    height: 177.h,
                    width: 1000.w,
                    imageAssetPress: 'assets/sc_23/privacy_press.png',
                    imageAssetUnPress: 'assets/sc_23/privacy_unpres.png',).marginOnly(bottom: 20.h),
                ),
                if (widget.data == '1')
                GestureDetector(
                  onTapDown: (_) => _handlegdprTap(true),
                  onTapUp: (_) => _handlegdprTap(false),
                  onTapCancel: _resestgdprTap,
                  child: BIG_PressUnpress(onTap: () async {
                    final didChangePreferences = await _initializationHelper
                        .changePrivacyPreferences();
                    Fluttertoast.showToast(
                        msg: didChangePreferences
                        ? 'Your privacy choices have been updated'
                            : 'An error occurred while trying to change your privacy choices',);
                    // Get.to(() => TermsOfUse());
                  },
                    height: 177.h,
                    width: 1000.w,
                    imageAssetPress: 'assets/sc_23/gdpr_press.png',
                    imageAssetUnPress: 'assets/sc_23/gdpr_unpress.png',).marginOnly(bottom: 20.h),
                ),
              ],
            ),
          ),
        ));
  }
}
