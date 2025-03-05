import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdService {
  static NativeAd? nativeAd;
  static ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  static ValueNotifier<bool> failed = ValueNotifier<bool>(false);


  static void loadNativeAd(String id) {
    print('=============================calling===========================');
    loaded.value = false;
    failed.value = false;
    nativeAd = NativeAd(
      adUnitId: id,
      factoryId: 'small',
      listener: NativeAdListener(onAdLoaded: (ad) {
        print(id);
        print(
            '=============================onAdLoaded===========================');
        loaded.value = true;
        failed.value = false;
      }, onAdFailedToLoad: (ad, error) {
        print(
            '=============================onAdFailedToLoad===========================');
        failed.value = true;
        loaded.value = false;
        nativeAd!.dispose();
      }),
      request: const AdRequest(),
    );
    nativeAd!.load();
  }

  void disposeNativeAd() {
    nativeAd?.dispose();
  }
}
