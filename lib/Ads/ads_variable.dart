import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsVariable {



  static bool isPurchase = false;


  static String big_normal_openAd = "ca-app-pub-3940256099942544/9257395921";

  static String big_pre_interstitialAd =
      "ca-app-pub-3940256099942544/1033173712";
  static String big_splash_interstitialAd =
      "ca-app-pub-3940256099942544/1033173712";
  static bool big_showOpenAdInSplash = false;


  static String big_appopen = "ca-app-pub-3940256099942544/9257395921";
  static String big_facebookId = "";
  static String big_facebookToken = "";


  // native intro
  static String big_nativeAd_intro =
      "ca-app-pub-3940256099942544/2247696110";
  static String big_nativeAd_intro_ios =
      "ca-app-pub-3940256099942544/2247696110";


  // native home
  static String big_nativeAd_home =
      "ca-app-pub-3940256099942544/2247696110";
  static String big_nativeAd_home_ios =
      "ca-app-pub-3940256099942544/2247696110";



  // static String big_intro_bannerAd = "ca-app-pub-3940256099942544/9214589741";
 //banner
  static String big_babygenerator_bannerAd = "ca-app-pub-3940256099942544/9214589741";
  static String big_babylook_bannerAd = "ca-app-pub-3940256099942544/9214589741";
  static String big_babyname_bannerAd = "ca-app-pub-3940256099942544/9214589741";
  static String big_babyage_bannerAd = "ca-app-pub-3940256099942544/9214589741";
  static String big_celebrity_bannerAd = "ca-app-pub-3940256099942544/9214589741";

  static int big_celebrity_creditcut = 5;
  static int big_babylook_creditcut = 5;
  static int big_babyname_creditcut = 5;
  static int big_babyage_creditcut = 5;
  static int big_babygenerator_creditcut = 5;


  // static String big_intro_bannerAd_ios = "11";


  static String big_nativeBgColor = "F6F6F6";
  static String big_headlineTxtColor = "000000";
  static String big_bodyTxtColor = "000000";
  static String big_buttonBgColor = "916AF4";
  static String big_buttonTextColor = "FFFFFF";

  // ///This Variable is Used To Show And Hide GDPR Button in Setting Screen
  static String dataGDPR = "";


 // click
  static int currentClick = 1;
  static int big_click = 2;
  static bool isShowingAd = false;

  static AppOpenAd? appOpenAd;
  static NativeAd? nativeAd;
  static NativeAd? Homenative;


  static void resetAllVariables() {
    big_normal_openAd = "11";
    big_pre_interstitialAd = "11";
    big_splash_interstitialAd = "11";
    big_appopen = "11";
    big_facebookId = "11";
    big_facebookToken = "11";

    // Native intro
    big_nativeAd_intro = "11";
    big_nativeAd_intro_ios = "11";

    // Native home
    big_nativeAd_home = "11";
    big_nativeAd_home_ios = "11";

    // Banners
    big_babygenerator_bannerAd = "11";
    big_babylook_bannerAd = "11";
    big_babyname_bannerAd = "11";
    big_babyage_bannerAd = "11";
    big_celebrity_bannerAd = "11";

    // UI colors
    big_nativeBgColor = "11";
    big_headlineTxtColor = "11";
    big_bodyTxtColor = "11";
    big_buttonBgColor = "11";
    big_buttonTextColor = "11";
    // isShowingAd = false;

  }

}

