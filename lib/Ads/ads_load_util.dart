import 'dart:async';

import 'package:babyimage/Ads/ads_variable.dart';
import 'package:babyimage/services/BIG_loading_screen.dart';
import 'package:babyimage/services/BIG_Shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_open_ad.dart';
import 'life_cycle.dart';

class AdsLoadUtil extends GetxController {
  late SharedPreferences prefs;
  late AppLifecycleReactor appLifecycleReactor;

  ///-----------_FOR BANNER AD IMPLEMENTATION ------------------------------------
  ///REFER: FILE NAMED: ads_banner_utils.dart or intro screen

  static void onShowAds(BuildContext context, Function onComplete) {
    if (AdsVariable.isPurchase) {
      onComplete();
      return;
    } else {
      if (AdsVariable.currentClick % AdsVariable.big_click == 0) {
        print("show =========");
        print(AdsVariable.currentClick);
        print(AdsVariable.big_click);
        AdsLoadUtil.showInterstitial(onDismissed: () {
          onComplete();
        });
      } else {
        onComplete();
        print("show =========");
        print(AdsVariable.currentClick);
      }
      AdsVariable.currentClick++;
    }

  }

  loadAppOpenAd() async {
    print("Load from BG...");
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()
      ..loadAd(AdsVariable.big_normal_openAd);
    appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: appOpenAdManager,
    );
    AppLifecycleReactor(appOpenAdManager: appOpenAdManager)
        .listenToAppStateChanges();
  }

  ///---------- load and show open ad in splash
  void loadAndShowOpenAd(
      Function onDismissed, String adId, Function loadPreLoadAds) {
    AppOpenAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) async {
          await loadPreLoadAds();
          print(
              "Ad Loaded:=====================================================================");
          ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('Ad showed full screen content');
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('$ad onAdFailedToShowFullScreenContent=======:- $error');

              Future.delayed(const Duration(seconds: 3), () {
                //Navigator.of(context).pop();
                onDismissed();
              });
            },
            onAdDismissedFullScreenContent: (ad) {
              onDismissed();

              ///CHANGES TO LOAD PRE LOAD AFTER SPLASH DISMISSED
              //TODO: CHANGES
              AdsLoadUtil.loadPreInterstitialAd(
                  adId: AdsVariable.big_pre_interstitialAd);
              print('$ad onAdDismissedFullScreenContent========:-');
            },
          );
        },
        onAdFailedToLoad: (error) {
          Future.delayed(const Duration(seconds: 3), () {
            onDismissed();
          });
          print(
              "Ad Not Loaded:=====================================================================");
          print(error);
        },
      ),
    );
  }


  /// ------- Load Common Inter (Mine) -----------------------------
  static InterstitialAd? _interstitialAd;
  static String interstitialId = "";
  static bool isAdLoaded = false;

  static loadPreInterstitialAd({required String adId}) {
    interstitialId = adId;
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
    }
    InterstitialAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdLoaded = true;
          print("Pre Inter Loaded");
        },
        onAdFailedToLoad: (error) {
          isAdLoaded = false;
          print("Pre Inter Failed $error");
        },
      ),
    );
  }

  static void showInterstitial({
    required Function onDismissed,
  }) {
    if (AdsVariable.isPurchase) {
      onDismissed();
      return;
    }
    if (isAdLoaded && _interstitialAd != null) {
      print("IT IS PRE LOADED");
      loadingScreen.show();
      // Delay showing the ad for 1500 milliseconds
      Future.delayed(const Duration(milliseconds: 100), () {
        loadingScreen.hide();
        // Close the loading dialog

        // Show the ad
        print("intersisial ads show");
        _interstitialAd!.show();
        print("show.......");
        print("full screen call back");
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdImpression: (ad) {
            print("onAdImpression---> true");
            Future.delayed(const Duration(milliseconds: 500), () {
              onDismissed();
            });
          },
          onAdDismissedFullScreenContent: (ad) {
            print("onAdDismissedFullScreenContent---> true");

            ad.dispose();
            _interstitialAd!
                .dispose()
                .then((value) => loadPreInterstitialAd(adId: interstitialId));
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            print("onAdFailedToShowFullScreenContent---> Error ${error}");
            ad.dispose();
            _interstitialAd!
                .dispose()
                .then((value) => loadPreInterstitialAd(adId: interstitialId));
            onDismissed();
          },
        );
      });
    } else {
      loadAndShow(
          adId: AdsVariable.big_pre_interstitialAd,
          onDismissed: onDismissed);
    }
  }

  // static void showInterstitial({
  //   required Function onDismissed,
  // }) {
  //   if (AdsVariable.isPurchase) {
  //     onDismissed();
  //     return;
  //   }
  //   if (isAdLoaded && _interstitialAd != null) {
  //     print(isAdLoaded);
  //     print(_interstitialAd);
  //     print("IT IS PRE LOADED");
  //     loadingScreen.show();
  //     // Delay showing the ad for 1500 milliseconds
  //     Future.delayed(const Duration(milliseconds: 1500), () {
  //       loadingScreen.hide();
  //       // Close the loading dialog
  //       // Show the ad
  //       _interstitialAd!.show();
  //       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //         onAdImpression: (ad) {
  //           print("onAdImpression---> true");
  //           Future.delayed(const Duration(milliseconds: 500), () {
  //             onDismissed();
  //           });
  //         },
  //         onAdDismissedFullScreenContent: (ad) {
  //           print("onAdDismissedFullScreenContent---> true");
  //           ad.dispose();
  //           _interstitialAd!.dispose().then((value) => loadPreInterstitialAd(adId: interstitialId));
  //         },
  //         onAdFailedToShowFullScreenContent: (ad, error) {
  //           print("onAdFailedToShowFullScreenContent---> Error ${error}");
  //           ad.dispose();
  //           _interstitialAd!
  //               .dispose()
  //               .then((value) => loadPreInterstitialAd(adId: interstitialId));
  //           onDismissed();
  //         },
  //       );
  //     });
  //   } else {
  //     loadAndShow(
  //         adId: AdsVariable.big_pre_interstitialAd, onDismissed: onDismissed);
  //   }
  // }


  /// ------ Splash screen inter load & show --------------------------------------------
  InterstitialAd? splashInterAd;

  loadInterSplash(Function() loadPreLoadAds, Function() navigateScreen,
      String adUnitId) async {
    prefs = await SharedPreferences.getInstance();
    print('>> SHOW INTER CALL <<');
    print('>> SHOW INTER CALL <<');
    print(
        'AdsVariable.appOpenSplashIOS >>${AdsVariable.big_splash_interstitialAd}');

    if (!AdsVariable.isPurchase) {
      InterstitialAd.load(
          adUnitId: adUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) async {
              print("AD LOADED");

              splashInterAd = ad;
              splashInterAd!.show();

              ///CHANGES IT FROM onAdShowedFullScreenContent To onAdLoaded
              //TODO: CHANGES
              await loadPreLoadAds();

              ad.fullScreenContentCallback = FullScreenContentCallback(
                  // Called when the ad showed the full screen content.
                  onAdShowedFullScreenContent: (ad) async {
                print("onAdShowedFullScreenContent loadInterSplash");
                print("onAdShowedFullScreenContent loadInterSplash");
              },
                  // Called when an impression occurs on the ad.
                  onAdImpression: (ad) async {
                print("onAdImpression loadInterSplash");
                print("onAdImpression loadInterSplash");
                Future.delayed(const Duration(milliseconds: 500)).then((value) {
                  navigateScreen();
                });
              },

                  // Called when the ad failed to show full screen content.
                  //
                  onAdFailedToShowFullScreenContent: (ad, err) async {
                // Dispose the ad here to free resources.
                ad.dispose();
                await loadPreLoadAds();
                print("onAdFailedToShowFullScreenContent loadInterSplash");
                print("onAdFailedToShowFullScreenContent loadInterSplash");
              },
                  // Called when the ad dismissed full screen content.
                  onAdDismissedFullScreenContent: (ad) async {
                // Dispose the ad here to free resources.

                ///CHANGES TO LOAD PRE LOAD AFTER SPLASH DISMISSED
                //TODO: CHANGES
                //AdsLoadUtil.loadPreInterstitialAd(adId: AdsVariable.big_pre_interstitialAd);
                ad.dispose();
                print("onAdDismissedFullScreenContent loadInterSplash");
              },
                  // Called when a click is recorded for an ad.
                  onAdClicked: (ad) {
                print("onAdClicked loadInterSplash");
              });

              print('$ad loaded.loadInterSplash ');
              // Keep a reference to the ad so you can show it later.
            },

            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) async {
              print('InterstitialAd failed to load loadInterSplash: $error');
              print('InterstitialAd failed to load loadInterSplash: $error');
              await loadPreLoadAds();
              navigateScreen();
            },
          ));
    }
  }

  ///---------------------- If Preload is not loaded then instantly load ad and show
  static void loadAndShow({
    required String adId,
    required Function onDismissed,
  }) {
    print("IT IS LOAD AND SHOW");
    isAdLoaded = false;
    loadingScreen.show();

    if (_interstitialAd != null) {
      showInterstitial(onDismissed: onDismissed);
    } else {
      interstitialId = adId;
      if (_interstitialAd != null) {
        _interstitialAd!.dispose();
      }
      InterstitialAd.load(
        adUnitId: adId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            loadingScreen.hide();
            _interstitialAd!.show();
            _interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdImpression: (ad) {
                Future.delayed(Duration(seconds: 1), () {
                  onDismissed();
                });
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                print("Ad Reloaded");
                loadPreInterstitialAd(adId: AdsVariable.big_pre_interstitialAd);
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                print("Ad Reloaded");
                loadPreInterstitialAd(adId: AdsVariable.big_pre_interstitialAd);
                onDismissed();
              },
            );
          },
          onAdFailedToLoad: (error) {
            loadingScreen.hide();
            onDismissed();
          },
        ),
      );
    }
  }

static  Future<bool> checkConnectivity() async {
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

  /// --------------------- Native ads load ------------------------------
  ///
  /// FOR OTHER ADS TAKE STATIC VARIABLES AS MUCH AS YOU WANT TO SHOW ADS
  /// EXAMPLE:
  /// static NativeAd? homeNativeAd (Declare it in AdsVariable File (Recommended))
  /// now wherever I want to preload this homeNativeAd
  /// I will pass
  /// AdsVariable.homeNativeAd = await AdsLoadUtil().loadNative(AdsVariable.big_home_nativeAd, false);
  /// --------------------- Native ads load ------------------------------
  static NativeAd? nativeAd;
  static RxBool isNativeAdLoaded = false.obs;
  static RxBool isNativeAdFailed = false.obs;

  static NativeAd? Homenativead;
  static RxBool isHomeNativeAdLoaded = false.obs;
  static RxBool isHomeNativeAdFailed = false.obs;


  Future<NativeAd> loadNative(String adUnitId, bool isSmallNative) async {
    print("isSmallNative--->$isSmallNative");
    isNativeAdLoaded.value = false;
    print("dddddddddddddddd");
    nativeAd = NativeAd(
      adUnitId: adUnitId.toString(),
      factoryId: isSmallNative ? 'small' : 'big',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          nativeAd = ad as NativeAd?;
          isNativeAdLoaded.value = true;
          print('isLoaded loadNative');
        },
        onAdFailedToLoad: (ad, error) {
          print('onAdFailedToLoad loadNative');
          nativeAd!.dispose();
          isNativeAdLoaded.value = false;
          isNativeAdFailed.value = true;
        },
      ),
      request: const AdRequest(),
    );

    await nativeAd!.load();
    return nativeAd!;
  }

  Future<NativeAd> loadHomeNative(String adUnitId, bool isSmallNative) async {
    print("isSmallNative--->$isSmallNative");
    isHomeNativeAdLoaded.value = false;
    Homenativead = NativeAd(
      adUnitId: adUnitId.toString(),
      factoryId: isSmallNative ? 'small' : 'big',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          Homenativead = ad as NativeAd?;
          isHomeNativeAdLoaded.value = true;
          print('isLoaded loadNative');
        },
        onAdFailedToLoad: (ad, error) {
          print('onAdFailedToLoad loadNative');
          Homenativead!.dispose();
          isHomeNativeAdLoaded.value = false;
          isHomeNativeAdFailed.value = true;
        },
      ),
      request: const AdRequest(),
    );
    await Homenativead!.load();
    return Homenativead!;
  }
}
  // Future<NativeAd> loadNative2(String adUnitId, bool isSmallNative) async {
  //   print("isSmallNative--->$isSmallNative");
  //   isNativeAdLoaded.value = false;
  //   print("dddddddddddddddd");
  //   nativeAd = NativeAd(
  //     adUnitId: adUnitId.toString(),
  //     factoryId: isSmallNative ? 'smallNativeAds' : 'bigNativeAds',
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         nativeAd = ad as NativeAd?;
  //         isNativeAdLoaded.value = true;
  //         print('isLoaded loadNative');
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         print('onAdFailedToLoad loadNative');
  //         nativeAd!.dispose();
  //         isNativeAdLoaded.value = false;
  //         isNativeAdFailed.value = true;
  //       },
  //     ),
  //     request: const AdRequest(),
  //   );
  //
  //   await nativeAd!.load();
  //   return nativeAd!;
  // }



// Future<NativeAd> loadHomeNative(String adUnitId, bool isSmallNative) async {
//   print("isSmallNative--->$isSmallNative");
//   isHomeNativeAdLoaded.value = false;
//   homenativeAd = NativeAd(
//     adUnitId: adUnitId.toString(),
//     factoryId: isSmallNative ? 'smallNativeAds' : 'bigNativeAds',
//     listener: NativeAdListener(
//       onAdLoaded: (ad) {
//         homenativeAd = ad as NativeAd?;
//         isHomeNativeAdLoaded.value = true;
//         print('isLoaded loadNative');
//       },
//       onAdFailedToLoad: (ad, error) {
//         print('onAdFailedToLoad loadNative');
//         homenativeAd!.dispose();
//         isHomeNativeAdLoaded.value = false;
//         isHomeNativeAdFailed.value = true;
//       },
//     ),
//     request: const AdRequest(),
//   );
//   await homenativeAd!.load();
//   return homenativeAd!;
// }

/// Native ads
class NativeAdsWidget extends StatefulWidget {
  final bool isSmallNative;
  final NativeAd? showNativeAd;

  const NativeAdsWidget(
      {super.key, required this.showNativeAd, required this.isSmallNative});

  @override
  State<NativeAdsWidget> createState() => _NativeAdsWidgetState();
}

/// Native ads
class _NativeAdsWidgetState extends State<NativeAdsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   print("AdsLoadUtil.isNativeAdLoaded--->${AdsLoadUtil.isNativeAdLoaded}");
    //   print("AdsLoadUtil.nativeAd------->${AdsLoadUtil.nativeAd}");
    //   if (widget.showNativeAd != null) {
    //     setState(() {
    //       //   showNativeAd = AdsLoadUtil.nativeAd;
    //     });
    //     print("AdsLoadUtil.nativeAd!.value if ------->${widget.showNativeAd}");
    //   } else {
    //     print("AdsLoadUtil.nativeAd!.value else------>");
    //   }
    // });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("CHECK NULL >> ${AdsLoadUtil.isNativeAdLoaded.value}");
    return Obx(() =>
    AdsLoadUtil.isNativeAdLoaded.value && widget.showNativeAd != null
        ? StatefulBuilder(builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
        ),
        padding: EdgeInsets.only(top: 0.w),
        width: 1242.w,
        height: widget.isSmallNative ? 300.h : 700.h,
        child: AdWidget(ad: widget.showNativeAd!),
      );
    })
        : getShimmerWidget());
  }

  Widget getShimmerWidget() {
    if (AdsLoadUtil.isNativeAdFailed.value) {
      return Container(
        height: 0,
      );
    } else {
      return widget.isSmallNative
          ? const BIG_ShimmerSmallNative()
          : const ShimmerBigNative();
    }
  }
}



class NativeHomeAdsWidget extends StatefulWidget {
  final bool isSmallNative;
  final NativeAd? showNativeAd;

  const NativeHomeAdsWidget(
      {super.key, required this.showNativeAd, required this.isSmallNative});

  @override
  State<NativeHomeAdsWidget> createState() => _NativeHomeAdsWidgetState();
}

/// Native ads
class _NativeHomeAdsWidgetState extends State<NativeHomeAdsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("CHECK NULL >> ${AdsLoadUtil.isHomeNativeAdLoaded.value}");
    return Obx(() =>
    AdsLoadUtil.isHomeNativeAdLoaded.value && widget.showNativeAd != null
        ? StatefulBuilder(builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.w),
        ),
        padding: EdgeInsets.only(top: 0.w),
        width: 1100.w,
        height: widget.isSmallNative ? 600.h : 600.h,
        child: AdWidget(ad: widget.showNativeAd!),
      );
    })
        : getShimmerWidget());
  }

  Widget getShimmerWidget() {
    if (!AdsLoadUtil.isHomeNativeAdLoaded.value) {
      print("value loaded");
      return Container(
        height: 0,
      );
    } else {
      return widget.isSmallNative
          ? const BIG_ShimmerSmallNative()
          : const ShimmerBigNative();
    }
  }
}

