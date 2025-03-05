import 'dart:io';
import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:babyimage/utils/BIG_ImageUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../Ads/ads_load_util.dart';
import '../../Ads/app_open_ad.dart';
import '../../Ads/life_cycle.dart';
import '../../services/BIG_Permission.dart';

class BIG_Imagepickupscreen extends StatefulWidget {
  final bool fatherimage;
  const BIG_Imagepickupscreen({super.key, required this.fatherimage});

  @override
  State<BIG_Imagepickupscreen> createState() => _BIG_ImagepickupscreenState();
}

class _BIG_ImagepickupscreenState extends State<BIG_Imagepickupscreen> {
  File? pickupImage;

  final BIG_ImageUtils imageUtils = BIG_ImageUtils();

  Future<void> _pickAndCropImage(bool isMother,
      {bool fromCamera = false}) async {
    await BIG_ImageUtils.requestPermissions();
    try {
      // Use different logic for Android and iOS if needed
      if (Platform.isAndroid) {
        // Android specific code for picking and cropping
        final pickedFile = await imageUtils.pickImage(fromCamera: fromCamera);
        if (pickedFile != null) {
          final croppedFile = await imageUtils.cropImage(pickedFile);
          setState(() {
            pickupImage = croppedFile;
            print("Android: isMother");
            print(pickupImage?.path); // Prints the path for Android
          });
        }
      } else if (Platform.isIOS) {
        // iOS specific code for picking and cropping
        final pickedFile = await imageUtils.pickImage(fromCamera: fromCamera);
        if (pickedFile != null) {
          final croppedFile = await imageUtils.cropImage(pickedFile);
          setState(() {
            pickupImage = croppedFile;
            print("iOS: isMother");
            print(pickupImage?.path); // Prints the path for iOS
          });
        }
      }
    } catch (e) {
      print("Error picking or cropping image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.fatherimage);
    return Scaffold(
      backgroundColor: LightThemeColors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.all(12),
            child: BIG_PressUnpress(
              onTap: () {
                Get.back();
              },
              height: 120.h,
              width: 120.w,
              imageAssetPress: 'assets/sc_7/Close_press.png',
              imageAssetUnPress: 'assets/sc_7/Close_unpress.png',
            )),
        backgroundColor: Colors.transparent,
        actions: [
          pickupImage == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.all(12),
                  child: BIG_PressUnpress(
                    onTap: () {
                      Get.back(result: pickupImage);
                    },
                    height: 120.h,
                    width: 120.w,
                    imageAssetPress: 'assets/sc_7/done_press.png',
                    imageAssetUnPress: 'assets/sc_7/done_unpress.png',
                  )),
        ],
      ),
      body: Container(
        height: 2208.h,
        width: 1242.w,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/sc_6/bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              height: 1300.h,
              width: 1100.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: (pickupImage == null)
                  ? Image.asset(
                      height: 417.h,
                      width: 515.w,
                      widget.fatherimage
                          ? 'assets/sc_7/boy_logo.png'
                          : 'assets/sc_7/girl_logo.png',
                      fit: BoxFit.contain,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.file(
                        pickupImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ).marginOnly(top: 250.h),
            // Button to pick an image from the camera

            BIG_PressUnpress(
              onTap: () async {
                if (await AdsLoadUtil.checkConnectivity()) {
                  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
                  AppLifecycleReactor appLifecycleListener =
                      AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
                  appLifecycleListener.listenToAppStateChanges(
                      shouldShow: false);
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (_) => Inapppurchase(item: true,home: true,)))
                  //     .then((onValue) {
                  //   appLifecycleListener.listenToAppStateChanges( shouldShow: true);
                  // });
                  await BIG_MyPermissionHandler.checkPermission('camera');
                  await _pickAndCropImage(widget.fatherimage, fromCamera: true);
                  appLifecycleListener.listenToAppStateChanges(
                      shouldShow: true);
                } else {
                  Fluttertoast.showToast(msg: "Please Turn On Internet");
                }
                // await MyPermissionHandler.checkPermission('camera');
                // _pickAndCropImage(widget.fatherimage, fromCamera: true);
              },
              height: 200.h,
              width: 1100.w,
              imageAssetPress: 'assets/sc_7/camera_press.png',
              imageAssetUnPress: 'assets/sc_7/camera_unpress.png',
            ),
            BIG_PressUnpress(
              onTap: () async {
                await BIG_MyPermissionHandler.checkPermission('gallery');
                _pickAndCropImage(widget.fatherimage);
              },
              height: 210.h,
              width: 1100.w,
              imageAssetPress: 'assets/sc_7/gallery_press.png',
              imageAssetUnPress: 'assets/sc_7/gallery_unpress.png',
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     _pickAndCropImage(widget.fatherimage, fromCamera: true);
            //   },
            //   child: Text("Pick image from camera"),
            // ),
            //
            // // Button to pick an image from the gallery
            // ElevatedButton(
            //   onPressed: () {
            //     _pickAndCropImage(widget.fatherimage);
            //   },
            //   child: Text("Pick image from gallery"),
            // ),
          ],
        ),
      ),
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
