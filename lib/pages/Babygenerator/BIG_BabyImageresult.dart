import 'package:babyimage/pages/BIG_Homepage.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:babyimage/utils/BIG_ImageUtils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Ads/ads_load_util.dart';

class BIG_Babyimageresult extends StatefulWidget {
  final String? imageurl;
  const BIG_Babyimageresult({super.key, required this.imageurl});

  @override
  State<BIG_Babyimageresult> createState() => _BIG_BabyimageresultState();
}

class _BIG_BabyimageresultState extends State<BIG_Babyimageresult> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{
          AdsLoadUtil.onShowAds(context, (){
              // Get.back();
            Get.offAll(() => BIG_Homepage());
          });
          return false;
        },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
          leading: Padding(
              padding: EdgeInsets.all(12),
              child: BIG_PressUnpress(
                onTap: () {
                  AdsLoadUtil.onShowAds(context, (){
                    // Get.back();
                    Get.offAll(() => BIG_Homepage());
                  });
                },
                unPressColor: Colors.transparent,
                height: 100.h,
                width: 100.w,
                imageAssetPress: 'assets/sc_6/back_press.png',
                imageAssetUnPress: 'assets/sc_8/back_unpress.png',
              )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "Result",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Container(
          height: 2208.h,
          width: 1242.w,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/sc_6/bg.png'), fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 1300.h,
                  width: 1100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: CachedNetworkImage(
                                    imageUrl: widget.imageurl!,
                                    fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CupertinoActivityIndicator(color: Colors.white,)
                      ),
                                  ),
                  ),
                ).marginOnly(top: 30.h),
                BIG_PressUnpress(
                  onTap: () async{
                      BIG_ImageUtils.showLoadingDialog(context);
                      await  BIG_ImageUtils.saveImageToGallery(widget.imageurl!);
                      BIG_ImageUtils.hideLoadingDialog(context);
                  },
                  unPressColor: Colors.transparent,
                  height: 200.h,
                  width: 1100.w,
                  imageAssetPress: 'assets/sc_10/save_image_press.png',
                  imageAssetUnPress: 'assets/sc_10/save_image_unpress.png',
                ).marginOnly(top: 80.h),
                BIG_PressUnpress(
                  onTap: () async{
                      BIG_ImageUtils.showLoadingDialog(context);
                      await BIG_ImageUtils.shareImageFromUrl(widget.imageurl!);
                      BIG_ImageUtils.hideLoadingDialog(context);
                  },
                  unPressColor: Colors.transparent,
                  height: 200.h,
                  width: 1100.w,
                  imageAssetPress: 'assets/sc_10/share_image_press.png',
                  imageAssetUnPress: 'assets/sc_10/share_image_unpress.png',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
