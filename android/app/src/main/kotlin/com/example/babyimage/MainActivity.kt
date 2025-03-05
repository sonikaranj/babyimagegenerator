package com.example.babyimage
//
//import android.view.LayoutInflater
//import android.view.View
//import android.widget.Button
//import android.widget.ImageView
//import android.widget.RatingBar
//import android.widget.TextView
//import com.google.android.gms.ads.nativead.NativeAd
//import com.google.android.gms.ads.nativead.NativeAdView
//import io.flutter.embedding.androidsm.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
//import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory
//
//
//class MainActivity : FlutterActivity() {
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
//        super.configureFlutterEngine(flutterEngine)
//        GoogleMobileAdsPlugin.registerNativeAdFactory(
//            flutterEngine,
//            "bigNativeAds",
//            NativeAdFactoryExample(layoutInflater)
//        )
//        GoogleMobileAdsPlugin.registerNativeAdFactory(
//            flutterEngine,
//            "smallNativeAds",
//            NativeAdFactory(layoutInflater)
//        )
//    }
//
//    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
//        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "bigNativeAds")
//        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallNativeAds")
//    }
//
//
//}
//
//class NativeAdFactoryExample : NativeAdFactory {
//    private var layoutInflater: LayoutInflater
//
//    constructor(layoutInflater: LayoutInflater) {
//        this.layoutInflater = layoutInflater
//    }
//
//    override fun createNativeAd(
//        nativeAd: NativeAd?,
//        customOptions: MutableMap<String, Any>?
//    ): NativeAdView {
//        val adView = layoutInflater.inflate(R.layout.my_native_ad, null) as NativeAdView
//
//        // Set the media view.
//        adView.mediaView = adView.findViewById(R.id.ad_media)
//
//        // Set other ad assets.
//        adView.headlineView = adView.findViewById(R.id.ad_headline)
//        adView.bodyView = adView.findViewById(R.id.ad_body)
//        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
//        adView.iconView = adView.findViewById(R.id.ad_app_icon)
////        adView.priceView = adView.findViewById(R.id.ad_price)
////        adView.starRatingView = adView.findViewById(R.id.ad_stars)
////        adView.storeView = adView.findViewById(R.id.ad_store)
//        adView.advertiserView = adView.findViewById(R.id.ad_advertiser)
//
//        // The headline and mediaContent are guaranteed to be in every NativeAd.
//        (adView.headlineView as TextView).text = nativeAd?.headline
//        adView.mediaView?.mediaContent = nativeAd?.mediaContent
//
//        // These assets aren't guaranteed to be in every NativeAd, so it's important to
//        // check before trying to display them.
//        if (nativeAd?.body == null) {
//            adView.bodyView?.visibility = View.INVISIBLE
//        } else {
//            adView.bodyView?.visibility = View.VISIBLE
//            (adView.bodyView as TextView).text = nativeAd.body
//        }
//
//        if (nativeAd?.callToAction == null) {
//            adView.callToActionView?.visibility = View.INVISIBLE
//        } else {
//            adView.callToActionView?.visibility = View.VISIBLE
//            (adView.callToActionView as Button).text = nativeAd.callToAction
//        }
//
//        if (nativeAd?.icon == null) {
//            adView.iconView?.visibility = View.GONE
//        } else {
//            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
//            adView.iconView?.visibility = View.VISIBLE
//        }
//
////        if (nativeAd?.price == null) {
////            adView.priceView?.visibility = View.INVISIBLE
////        } else {
////            adView.priceView?.visibility = View.VISIBLE
////            (adView.priceView as TextView).text = nativeAd.price
////        }
////
////        if (nativeAd?.store == null) {
////            adView.storeView?.visibility = View.INVISIBLE
////        } else {
////            adView.storeView?.visibility = View.VISIBLE
////            (adView.storeView as TextView).text = nativeAd.store
////        }
//
////        if (nativeAd?.starRating == null) {
////            adView.starRatingView?.visibility = View.INVISIBLE
////        } else {
////            (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
////            adView.starRatingView?.visibility = View.VISIBLE
////        }
//
//        if (nativeAd?.advertiser == null) {
//            adView.advertiserView?.visibility = View.GONE
//        } else {
//            adView.advertiserView?.visibility = View.VISIBLE
//            (adView.advertiserView as TextView).text = nativeAd.advertiser
//        }
//
//        // This method tells the Google Mobile Ads SDK that you have finished populating your
//        // native ad view with this native ad.
//        if (nativeAd != null) {
//            adView.setNativeAd(nativeAd)
//        }
//
//        return adView
//    }
//}
//
//class NativeAdFactory : NativeAdFactory {
//    private var layoutInflater: LayoutInflater
//
//    constructor(layoutInflater: LayoutInflater) {
//        this.layoutInflater = layoutInflater
//    }
//
//    override fun createNativeAd(
//        nativeAd: NativeAd?,
//        customOptions: MutableMap<String, Any>?
//    ): NativeAdView {
//        val adView = layoutInflater.inflate(R.layout.list_tile_native_ad, null) as NativeAdView
//
//        // Set the media view.
//
//        // Set other ad assets.
//        adView.headlineView = adView.findViewById(R.id.ad_headline)
//        adView.bodyView = adView.findViewById(R.id.ad_body)
//        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
//        adView.iconView = adView.findViewById(R.id.ad_app_icon)
//        adView.advertiserView = adView.findViewById(R.id.ad_advertiser)
//
//        // The headline and mediaContent are guaranteed to be in every NativeAd.
//        (adView.headlineView as TextView).text = nativeAd?.headline
//
//        if (nativeAd?.body == null) {
//            adView.bodyView?.visibility = View.INVISIBLE
//        } else {
//            adView.bodyView?.visibility = View.VISIBLE
//            (adView.bodyView as TextView).text = nativeAd.body
//        }
//
//        if (nativeAd?.callToAction == null) {
//            adView.callToActionView?.visibility = View.INVISIBLE
//        } else {
//            adView.callToActionView?.visibility = View.VISIBLE
//            (adView.callToActionView as Button).text = nativeAd.callToAction
//        }
//
//        if (nativeAd?.icon == null) {
//            adView.iconView?.visibility = View.GONE
//        } else {
//            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
//            adView.iconView?.visibility = View.VISIBLE
//        }
//
//        if (nativeAd?.advertiser == null) {
//            adView.advertiserView?.visibility = View.GONE
//        } else {
//            adView.advertiserView?.visibility = View.VISIBLE
//            (adView.advertiserView as TextView).text = nativeAd.advertiser
//        }
//
//        if (nativeAd != null) {
//            adView.setNativeAd(nativeAd)
//        }
//
//        return adView
//    }
//}
//
//


import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine,"small",NativeAdFactorySmall(layoutInflater))
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine,"big",NativeAdFactoryBig(layoutInflater))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "small")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "big")
    }
}

class NativeAdFactorySmall: NativeAdFactory {
    private var layoutInflater: LayoutInflater

    constructor(layoutInflater: LayoutInflater) {
        this.layoutInflater = layoutInflater
    }

    override fun createNativeAd(nativeAd: NativeAd?, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.small_template, null) as NativeAdView

        // Set the media view.
        /*adView.mediaView = adView.findViewById(R.id.ad_media)*/

        // Set other ad assets.
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.iconView = adView.findViewById(R.id.ad_app_icon)
        //adView.priceView = adView.findViewById(R.id.native_ad_attribution_small)
        adView.starRatingView = adView.findViewById(R.id.ad_stars)
        /*adView.storeView = adView.findViewById(R.id.ad_store)*/
        /*adView.advertiserView = adView.findViewById(R.id.ad_advertiser)*/

        // The headline and mediaContent are guaranteed to be in every NativeAd.
        (adView.headlineView as TextView).text = nativeAd?.headline
        /*adView.mediaView?.mediaContent = nativeAd?.mediaContent*/

        // These assets aren't guaranteed to be in every NativeAd, so it's important to
        // check before trying to display them.
        if (nativeAd?.body == null) {
            adView.bodyView?.visibility = View.INVISIBLE
        } else {
            adView.bodyView?.visibility = View.VISIBLE
            (adView.bodyView as TextView).text = nativeAd.body
        }

        if (nativeAd?.callToAction == null) {
            adView.callToActionView?.visibility = View.INVISIBLE
        } else {
            adView.callToActionView?.visibility = View.VISIBLE
            (adView.callToActionView as Button).text = nativeAd.callToAction
        }

        if (nativeAd?.icon == null) {
            adView.iconView?.visibility = View.GONE
        } else {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
            adView.iconView?.visibility = View.VISIBLE
        }

        /* if (nativeAd?.price == null) {
             adView.priceView?.visibility = View.INVISIBLE
         } else {
             adView.priceView?.visibility = View.VISIBLE
             (adView.priceView as TextView).text = nativeAd.price
         }*/

        /*   if (nativeAd?.store == null) {
               adView.storeView?.visibility = View.INVISIBLE
           } else {
               adView.storeView?.visibility = View.VISIBLE
               (adView.storeView as TextView).text = nativeAd.store
           }*/

        if (nativeAd?.starRating == null) {
            adView.starRatingView?.visibility = View.INVISIBLE
        } else {
            (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
            adView.starRatingView?.visibility = View.VISIBLE
        }

        /* if (nativeAd?.advertiser == null) {
             adView.advertiserView?.visibility = View.INVISIBLE
         } else {
             adView.advertiserView?.visibility = View.VISIBLE
             (adView.advertiserView as TextView).text = nativeAd.advertiser
         }*/

        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        if (nativeAd != null) {
            adView.setNativeAd(nativeAd)
        }

        return adView
    }
}

class NativeAdFactoryBig: NativeAdFactory {
    private var layoutInflater: LayoutInflater

    constructor(layoutInflater: LayoutInflater) {
        this.layoutInflater = layoutInflater
    }

    override fun createNativeAd(nativeAd: NativeAd?, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.big_template, null) as NativeAdView

        // Set the media view.
        adView.mediaView = adView.findViewById(R.id.native_ad_media)

        // Set other ad assets.
//        adView.view = adView.findViewById(R.id.native_ad_view)
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.iconView = adView.findViewById(R.id.ad_app_icon)
        //adView.priceView = adView.findViewById(R.id.native_ad_attribution_small)
        adView.starRatingView = adView.findViewById(R.id.ad_stars)
        /*adView.storeView = adView.findViewById(R.id.ad_store)*/
        /*adView.advertiserView = adView.findViewById(R.id.ad_advertiser)*/

        // The headline and mediaContent are guaranteed to be in every NativeAd.
        (adView.headlineView as TextView).text = nativeAd?.headline
        adView.mediaView?.mediaContent = nativeAd?.mediaContent

        android.util.Log.d("TAG1", "createNativeAd: "+adView.mediaView)
        android.util.Log.d("TAG1", "createNativeAd: "+adView.mediaView?.mediaContent)
        android.util.Log.d("TAG1", "createNativeAd: "+nativeAd?.body)
        android.util.Log.d("TAG1", "createNativeAd: "+nativeAd?.mediaContent)

//        if(nativeAd?.mediaContent == null){
//            adView.mediaView?.visibility = View.GONE
//            adView.view?.visibility = View.VISIBLE
//        }else{
//            adView.mediaView?.visibility = View.VISIBLE
//            adView.view?.visibility = View.GONE
//        }

        // These assets aren't guaranteed to be in every NativeAd, so it's important to
        // check before trying to display them.
        if (nativeAd?.body == null) {
            adView.bodyView?.visibility = View.INVISIBLE
        } else {
            adView.bodyView?.visibility = View.VISIBLE
            (adView.bodyView as TextView).text = nativeAd.body
        }

        if (nativeAd?.callToAction == null) {
            adView.callToActionView?.visibility = View.INVISIBLE
        } else {
            adView.callToActionView?.visibility = View.VISIBLE
            (adView.callToActionView as Button).text = nativeAd.callToAction
        }

        if (nativeAd?.icon == null) {
            adView.iconView?.visibility = View.GONE
        } else {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon!!.drawable)
            adView.iconView?.visibility = View.VISIBLE
        }

        /* if (nativeAd?.price == null) {
             adView.priceView?.visibility = View.INVISIBLE
         } else {
             adView.priceView?.visibility = View.VISIBLE
             (adView.priceView as TextView).text = nativeAd.price
         }*/

        /*   if (nativeAd?.store == null) {
               adView.storeView?.visibility = View.INVISIBLE
           } else {
               adView.storeView?.visibility = View.VISIBLE
               (adView.storeView as TextView).text = nativeAd.store
           }*/

        if (nativeAd?.starRating == null) {
            adView.starRatingView?.visibility = View.INVISIBLE
        } else {
            (adView.starRatingView as RatingBar).rating = nativeAd.starRating!!.toFloat()
            adView.starRatingView?.visibility = View.VISIBLE
        }

        /* if (nativeAd?.advertiser == null) {
             adView.advertiserView?.visibility = View.INVISIBLE
         } else {
             adView.advertiserView?.visibility = View.VISIBLE
             (adView.advertiserView as TextView).text = nativeAd.advertiser
         }*/

        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        if (nativeAd != null) {
            adView.setNativeAd(nativeAd)
        }

        return adView
    }
}
