import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:babyimage/Ads/ads_variable.dart';
import 'package:babyimage/Inapppurchase/store_config.dart';
import 'package:babyimage/const/global/globalapi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Inapppurchase/constant.dart';
import 'ads_load_util.dart';
import 'app_open_ad.dart';
import 'life_cycle.dart';

class AdsSplashUtils {
  late SharedPreferences prefs;

  getOnlineIds(Function() preLoads, Function() navigateScreen) async {
    log("In Get Ads");
    prefs = await SharedPreferences.getInstance();

    //if (Platform.isIOS) premiumInit();

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

    showLog(String msg) {
      print("LOG >> $msg");
    }

    if (await checkConnectivity()) {
      try {
        // await Firebase.initializeApp().then((value) {
        //   print("Firebase Initialized");
        // });
        await   Firebase.initializeApp(
            options: FirebaseOptions(
              apiKey: 'AIzaSyBky4cCNW-4qeGkCXysd6HAqWyn0NHto6c',
              appId: '1:956400082004:android:77130d81b7cf0d0ac221c1',
              messagingSenderId: '956400082004',
              projectId: 'babyimagegenerate',
              storageBucket: 'babyimagegenerate.appspot.com',
              // apiKey: 'AIzaSyCzR1uDT_DZubPjk2ubSQm65FGflI0cz6E',
              // appId: '1:22233247525:ios:65c1ba553249c68df834cc',
              // messagingSenderId: '22233247525',
              // projectId: 'ds-demo-test',
              // storageBucket: 'ds-demo-test.appspot.com',
            ));
        final remoteConfig = FirebaseRemoteConfig.instance;
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 5),
        ));

        await remoteConfig.fetchAndActivate();
        log("Map is ${remoteConfig.getValue("key").asString()}");
        Map<String, dynamic> mapValues1 =
            jsonDecode(remoteConfig.getValue("key").asString());
        log("map is ${mapValues1}");


        AdsVariable.big_normal_openAd = mapValues1['big_normal_openAd'].toString();
        print(AdsVariable.big_normal_openAd);
        AdsVariable.big_pre_interstitialAd = mapValues1['big_pre_interstitialAd'].toString();
        AdsVariable.big_splash_interstitialAd = mapValues1['big_splash_interstitialAd'].toString();
        AdsVariable.big_showOpenAdInSplash = mapValues1['big_showOpenAdInSplash'] ?? false;

        AdsVariable.big_appopen = mapValues1['big_appopen'].toString();
        AdsVariable.big_facebookId = mapValues1['big_facebookId'].toString();
        AdsVariable.big_facebookToken = mapValues1['big_facebookToken'].toString();

        // Native ads
        AdsVariable.big_nativeAd_intro = mapValues1['big_nativeAd_intro'].toString();
        AdsVariable.big_nativeAd_intro_ios = mapValues1['big_nativeAd_intro_ios'].toString();
        AdsVariable.big_nativeAd_home = mapValues1['big_nativeAd_home'].toString();
        AdsVariable.big_nativeAd_home_ios = mapValues1['big_nativeAd_home_ios'].toString();

        // Banner ads
        AdsVariable.big_babygenerator_bannerAd = mapValues1['big_babygenerator_bannerAd'].toString();
        AdsVariable.big_babylook_bannerAd = mapValues1['big_babylook_bannerAd'].toString();
        AdsVariable.big_babyname_bannerAd = mapValues1['big_babyname_bannerAd'].toString();
        AdsVariable.big_babyage_bannerAd = mapValues1['big_babyage_bannerAd'].toString();
        AdsVariable.big_celebrity_bannerAd = mapValues1['big_celebrity_bannerAd'].toString();

        // Colors
        AdsVariable.big_nativeBgColor = mapValues1['big_nativeBgColor'].toString();
        AdsVariable.big_headlineTxtColor = mapValues1['big_headlineTxtColor'].toString();
        AdsVariable.big_bodyTxtColor = mapValues1['big_bodyTxtColor'].toString();
        AdsVariable.big_buttonBgColor = mapValues1['big_buttonBgColor'].toString();
        AdsVariable.big_buttonTextColor = mapValues1['big_buttonTextColor'].toString();

        // GDPR
        // AdsVariable.dataGDPR = mapValues1['dataGDPR'].toString();


        //api variable set
        Globals.babyname =mapValues1['babyname'].toString();
        Globals.clebritydetection =mapValues1['clebritydetection'].toString();
        Globals.babyllok =mapValues1['babyllok'].toString();
        Globals.agedetection =mapValues1['agedetection'].toString();
        Globals.babygenerator =mapValues1['babygenerator'].toString();

        // Click counts and ad display
        AdsVariable.currentClick = mapValues1['currentClick'] ?? 0;
        AdsVariable.big_click = mapValues1['big_click'] ?? 2;
        AdsVariable.isShowingAd = mapValues1['isShowingAd'] ?? false;

        /// IOS Id setup from Firebase Remote Config
        /// Facebook id setup
        // AdsVariable.big_facebookId = mapValues1['big_facebookId'].toString();
        // AdsVariable.big_facebookToken = mapValues1[facebookToken].toString();
        //
        // AdsVariable.big_appopen = mapValues1[appOpenAd].toString();
        // AdsVariable.big_fullscreen_splash_screen =
        //     mapValues1[splashInterstitialAd].toString();
        // AdsVariable.SV_fullscreen_homepage_screen =
        //     mapValues1[preInterstitialAd].toString();
        //
        // AdsVariable.SV_native_language_screen =
        //     mapValues1[languageNativeAd].toString();
        //
        // AdsVariable.SV_banner_intro_screen = mapValues1[introBannerAd].toString();
        // AdsVariable.SV_banner_favorite = mapValues1[homeBannerAd].toString();
        // AdsVariable.SV_banner_city_world = mapValues1[pinBannerAd].toString();
        //
        // AdsVariable.SV_banner_famous_place =
        //     mapValues1[previewBannerAd].toString();
        // AdsVariable.SV_banner_seven_wonder =
        //     mapValues1[mainMusicSelectBannerAd].toString();
        // AdsVariable.SV_banner_more_watch =
        //     mapValues1[mainMusicSelectBannerAd].toString();
        //
        // AdsVariable.SV_click = int.parse(mapValues1[click].toString());
        //
        // AdsVariable.SV_nativeBGColor = mapValues1[nativeBgColor].toString();
        // AdsVariable.SV_headerTextColor =
        //     mapValues1[headlineTxtColor].toString();
        // AdsVariable.SV_bodyTextColor = mapValues1[bodyTxtColor].toString();
        // AdsVariable.SV_btnBgColor = mapValues1[buttonBgColor].toString();
        // AdsVariable.SV_btnTextColor =
        //     mapValues1[buttonTxtColor].toString();
        // AdsVariable.SV_showOpenAdInSplash = mapValues1[showOpenAdInSplash];


        /// Store firebase remote config data into shared preferences :
        // prefs.setString(nativeBgColor, mapValues1[nativeBgColor].toString());
        // prefs.setString(buttonBgColor, mapValues1[buttonBgColor].toString());
        // prefs.setString(buttonTxtColor, mapValues1[buttonTxtColor].toString());
        // prefs.setString(
        //     headlineTxtColor, mapValues1[headlineTxtColor].toString());
        // prefs.setString(bodyTxtColor, mapValues1[bodyTxtColor].toString());
        //
        // prefs.setString(facebookId, mapValues1[facebookId].toString());
        // prefs.setString(facebookToken, mapValues1[facebookToken].toString());
        //
        // prefs.setString(appOpenAd, mapValues1[appOpenAd] ?? "11");
        // prefs.setString(
        //     splashInterstitialAd, mapValues1[splashInterstitialAd] ?? "11");
        // prefs.setString(
        //     preInterstitialAd, mapValues1[preInterstitialAd] ?? "11");
        // prefs.setString(introBannerAd, mapValues1[introBannerAd] ?? "11");
        // prefs.setString(homeBannerAd, mapValues1[homeBannerAd] ?? "11");
        // prefs.setString(pinBannerAd, mapValues1[pinBannerAd] ?? "11");
        //
        // prefs.setString(previewBannerAd, mapValues1[previewBannerAd] ?? "11");
        // prefs.setString(mainMusicSelectBannerAd,
        //     mapValues1[mainMusicSelectBannerAd] ?? "11");
        // prefs.setString(
        //     soundListBannerAd, mapValues1[soundListBannerAd] ?? "11");
        //
        // prefs.setInt(click, mapValues1[click] ?? 2);
        // prefs.setBool(
        //     showOpenAdInSplash, mapValues1[showOpenAdInSplash] ?? false);

         // Facebook id setup
        setupFbAdsId();

         // In app purchase
         if (Platform.isIOS) configureSDK();

         // GDPR Consent form init
         await initializeGDPR();

         // Check available purchases
         if (Platform.isIOS) {
           await fetchPurchase();
         }

        if (AdsVariable.isPurchase) {
          Future.delayed(const Duration(seconds: 3), () {
            navigateScreen();
          });
          return;
        }
        if (AdsVariable.big_showOpenAdInSplash) {
          AdsLoadUtil().loadAndShowOpenAd(
              navigateScreen, AdsVariable.big_appopen, preLoads);
        } else {
          print("+++++++++++++");
          AdsLoadUtil().loadInterSplash(preLoads, navigateScreen,
              AdsVariable.big_splash_interstitialAd);
        }
      } on PlatformException catch (exception) {
        Future.delayed(Duration(seconds: 3), () {
          navigateScreen();
        });
        print("Exception is $exception");
      } catch (exception) {
        Future.delayed(Duration(seconds: 3), () {
          navigateScreen();
        });
        print("Exception is $exception");
      }
    } else {
      log("Not Connected");

      Future.delayed(Duration(seconds: 3), () {
        navigateScreen();
      });

      /// Facebook id setup
    }
  }

  late AppLifecycleReactor appLifecycleReactor;

  fetchPurchase() async {
    try {
      if (Platform.isIOS) {
        final customerInfo = await Purchases.getCustomerInfo();
        if (customerInfo.entitlements.all[entitlementKey] != null &&
            customerInfo.entitlements.all[entitlementKey]!.isActive == true) {
          AdsVariable.isPurchase = true;
          //make all ads id 11
        } else {
          AdsVariable.isPurchase = false;
        }
      }
      if (AdsVariable.isPurchase) {
        print("Purchase ----->${AdsVariable.isPurchase}");
        // AdsVariable.resetAdIds();
        //make all id 11
      }
    } catch (e) {
      print("PURCHASE_ERROR >> ${e.toString()}");
    }
  }
}

premiumInit() {
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazon : Store.playStore,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }
}

setupFbAdsId() async {
  print("Call 1");
  const platformMethodChannel = MethodChannel('nativeChannel');
  print("Call 2");
  platformMethodChannel.invokeMethod('setToast', {
    'isPurchase': AdsVariable.isPurchase.toString(),
    'facebookId': AdsVariable.big_facebookId,
    'facebookToken': AdsVariable.big_facebookToken,
    'nativeBGColor': AdsVariable.big_nativeBgColor,
    'btnBgColor': AdsVariable.big_buttonBgColor,
    'btnTextColor': AdsVariable.big_buttonTextColor,
    'headerTextColor': AdsVariable.big_headlineTxtColor,
    'bodyTextColor': AdsVariable.big_bodyTxtColor,
  });
  print("Call 3");
}

// void loadPreLoadAds() async {
//   print("Call Method loadPreLoadAds");
//
//   await SharedPreferenceUtils.getBoolean("firstTime").then((onValue) async {
//     print("AdsVariable.isFirstTime---->${onValue}");
//     if (onValue == true) {
//       AdsVariable.nativeAdLanguage = await AdsLoadUtil().loadNative(
//         AdsVariable.dtmd_language_nativeAd,
//         false,
//       );
//       print("AdsVariable.nativeAdLanguage --->${AdsVariable.nativeAdLanguage}");
//     }
//   });
// }

Future<void> configureSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);
  print('==========setLogLevel=============');
  PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppstore()) {
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey);
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
  }
  configuration.entitlementVerificationMode =
      EntitlementVerificationMode.informational;
  await Purchases.configure(configuration);
  await Purchases.enableAdServicesAttributionTokenCollection();
}

/// GDPR Implementation methods : initializeGDPR, changePrivacyPreferences, loadConsentForm, initializeMobileAds
Future<FormError?> initializeGDPR() async {
  final completer = Completer<FormError?>();
  final params = ConsentRequestParameters(
    consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: ['F7354E44C81CDB7898515E111F6BFCE5']),
  );
  ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
    if (await ConsentInformation.instance.isConsentFormAvailable()) {
      await loadConsentForm();
    } else {
      await initializeMobileAds();
    }
    completer.complete();
  }, (error) {
    completer.complete(error);
  });

  return completer.future;
}

Future<bool> changePrivacyPreferences() async {
  final completer = Completer<bool>();

  ConsentInformation.instance
      .requestConsentInfoUpdate(ConsentRequestParameters(), () async {
    if (await ConsentInformation.instance.isConsentFormAvailable()) {
      ConsentForm.loadConsentForm((consentForm) {
        consentForm.show((formError) async {
          await initializeMobileAds();
          completer.complete(true);
        });
      }, (formError) {
        completer.complete(false);
      });
    } else {
      completer.complete(false);
    }
  }, (error) {
    completer.complete(false);
  });

  return completer.future;
}

Future<FormError?> loadConsentForm() async {
  final completer = Completer<FormError?>();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  ConsentForm.loadConsentForm((consentForm) async {
    final status = await ConsentInformation.instance.getConsentStatus();
    if (status == ConsentStatus.required) {
      consentForm.show((formError) async {
        completer.complete(loadConsentForm());
        print("GDRP IF");
        await preferences.setString('keyvalue', "1");
        AdsVariable.dataGDPR = (preferences.getString('keyvalue'))!;
      });
    } else {
      print("GDRP else");
      await preferences.setString('keyvalue', "0");
      AdsVariable.dataGDPR = (preferences.getString('keyvalue'))!;
      await initializeMobileAds();
      completer.complete();
    }
  }, (FormError? error) {
    completer.complete(error);
  });

  return completer.future;
}

Future<void> initializeMobileAds() async {
  await MobileAds.instance.initialize();
}
