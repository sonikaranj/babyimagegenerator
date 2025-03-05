// ignore_for_file: avoid_print
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:babyimage/Ads/ads_load_util.dart';
import 'package:babyimage/Ads/ads_variable.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_splash_utils.dart';
import 'app_open_ad.dart';

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges({bool shouldShow = true}) {
    print("AppLifecycleReactor Listen Called");
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((state) {
      print("AppLifecycleReactor Should Show $shouldShow");
      print("State is ${state}");
      if (shouldShow && !AdsVariable.isPurchase) {
         onAppStateChanged(state);
      }else{
        print("NOT SHOW");
      }
    });
  }

  void onAppStateChanged(AppState appState) {
    print("In ON APP STATE CHANGED");
    if (appState == AppState.foreground) {
      debugPrint("App State :- $appState");
      print('FOREGROUND');

      appOpenAdManager.showAdIfAvailable(AdsVariable.big_normal_openAd);
    }else if(appState==AppState.background){
      print("karan");
      print(AdsVariable.big_normal_openAd);
      ///TODO: CHANGES
      print('BACKGROUND');
      ///When App Go In Background If Ad is not available then it will load open Ad
      if (!AppOpenAdManager().isAdAvailable) {
        print("AD NOT AVAILABLE");
        AdsLoadUtil().loadAppOpenAd();
      }
    }
  }
}
