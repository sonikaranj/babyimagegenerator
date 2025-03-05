import 'package:purchases_flutter/purchases_flutter.dart';
import '../Ads/ads_variable.dart';
import 'constant.dart';

class CheckPurchasesStatus {
  static Future<bool> initPlatformState() async {
    try{
      final customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all[entitlementKey] != null && customerInfo.entitlements.all[entitlementKey]!.isActive == true) {
        AdsVariable.isPurchase = true;
        AdsVariable.big_splash_interstitialAd = '11';
        AdsVariable.big_pre_interstitialAd = '11';
        // AdsVariable.big_language_nativeAd = '11';
        // AdsVariable.big_nativeAd = '11';
        //
        // AdsVariable.big_nativeAd_ios = '11';
        // AdsVariable.big_intro_bannerAd = '11';
        // AdsVariable.big_intro_bannerAd_ios = '11';
        AdsVariable.big_appopen = '11';

        // AdsVariable.big_home_bannerAd = '11';
        // AdsVariable.big_pin_bannerAd = '11';
        // AdsVariable.big_preview_bannerAd = '11';
        // AdsVariable.big_main_music_select_bannerAd = '11';
        // AdsVariable.big_sound_list_bannerAd = '11';
        return true;
      } else {
        return false;
      }
    }catch(e){
      return false;
    }
  }
  static notShowads() async {
    //var credit = await SharedPreferencesService.getCreditValue('Credit');
    // if(credit >= 10){
    //
    // }
  }
}