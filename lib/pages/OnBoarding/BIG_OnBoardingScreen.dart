import 'dart:io';

import 'package:babyimage/Ads/ads_load_util.dart';
import 'package:babyimage/Ads/ads_variable.dart';
import 'package:babyimage/Ads/nativeAdService.dart';
import 'package:babyimage/Inapppurchase/app.dart';
import 'package:babyimage/pages/BIG_Homepage.dart';
import 'package:babyimage/Inapppurchase/credit/BIG_InappPurchase.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:babyimage/services/BIG_Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BIG_OnBoardingScreen extends StatefulWidget {
  const BIG_OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<BIG_OnBoardingScreen> createState() => _BIG_OnBoardingScreenState();
}

class _BIG_OnBoardingScreenState extends State<BIG_OnBoardingScreen> {
  late PageController _pageViewController;
  int _currentPageIndex = 0;
  final int pageLength = 4;

  final List<String> pageImages = [
    'assets/sc_1/logo.png',
    'assets/sc_2/logo.png',
    'assets/sc_3/logo.png',
    'assets/sc_4/logo.png',
  ];

  final List<String> textImages = [
    'assets/sc_1/text.png',
    'assets/sc_2/text.png',
    'assets/sc_3/text.png',
    'assets/sc_4/text.png',
  ];

  @override
  void initState() {
    super.initState();
    if (AdsVariable.isPurchase == false) {
      if (AdsVariable.big_nativeAd_intro == null) {
        if (Platform.isAndroid) {
          if (NativeAdService.failed.value &&
              AdsVariable.big_nativeAd_intro != '11') {
            NativeAdService.loadNativeAd(AdsVariable.big_nativeAd_intro);
          }
        } else if (Platform.isIOS) {
          if (NativeAdService.failed.value &&
              AdsVariable.big_nativeAd_intro_ios != '11') {
            NativeAdService.loadNativeAd(AdsVariable.big_nativeAd_intro_ios);
          }
        }
      }
    }

    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();

    AdsVariable.nativeAd!.dispose();
    AdsVariable.nativeAd = null;
    AdsLoadUtil.isNativeAdLoaded.value = false;
    super.dispose();
  }

  Future<void> setLoginStatus(bool isLogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', isLogin);
  }

  void _onNextPressed() {
    if (_currentPageIndex < pageLength - 1) {
      setState(() {
        _currentPageIndex++;
        _pageViewController.animateToPage(
          _currentPageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    } else {
      setLoginStatus(true);
      if (AdsVariable.isPurchase == false) {
        Get.to(() => BIG_Inapppurchase(
              item: true,
            ));
      } else {
        Get.to(() => BIG_Homepage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 1284.h,
              width: 1242.w,
              child: PageView(
                controller: _pageViewController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(() {
                    _currentPageIndex = value;
                  });
                },
                children: List.generate(pageLength, (index) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          pageImages[index],
                          height: 980.h,
                          width: 1242.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        bottom: 130.h,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            textImages[index],
                            height: 200.h,
                            width: 1242.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 20.h,
                    width: 240.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/sc_1/swipe_${_currentPageIndex + 1}.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ).marginOnly(left: 50.w),
                  BIG_PressUnpress(
                    onTap: _onNextPressed,
                    height: 178.h,
                    width: 178.w,
                    imageAssetPress: _currentPageIndex < pageLength - 1
                        ? 'assets/sc_1/next_press.png'
                        : 'assets/sc_4/done_press.png',
                    imageAssetUnPress: _currentPageIndex < pageLength - 1
                        ? 'assets/sc_1/next_unpress.png'
                        : 'assets/sc_4/done._unpress.png',
                  ).marginOnly(right: 50.w),
                ],
              ),
            ),
            Spacer(),
            if (!AdsVariable.isPurchase)
              ValueListenableBuilder<bool>(
                valueListenable: NativeAdService.loaded,
                builder: (context, loaded, _) {
                  if (loaded && AdsVariable.big_nativeAd_intro != '11') {
                    final Container adContainer = Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 475.h,
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      child: AdWidget(ad: NativeAdService.nativeAd!),
                    );
                    return adContainer;
                  } else if (!NativeAdService.loaded.value &&
                      AdsVariable.big_nativeAd_intro != '11') {
                    return BIG_ShimmerSmallNative();
                  } else {
                    return SizedBox(height: 425.h);
                  }
                },
              ),
            //       (AdsVariable.big_nativeAd_intro != "11")
            // ? AdsVariable.nativeAd == null ? CircularProgressIndicator() : NativeAdsWidget(showNativeAd: AdsVariable.nativeAd, isSmallNative: true)
            // : Container(height: 0,),
            SizedBox(
              height: 5.h,
            )
          ],
        ),
      ),
    );
  }
}
