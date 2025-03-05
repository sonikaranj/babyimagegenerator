import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/const/global/globalapi.dart';
import 'package:babyimage/pages/Babygenerator/BIG_Babyimagegeneratorapi.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:babyimage/utils/BIG_ImageUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Ads/Bannerads.dart';
import '../../Ads/ads_load_util.dart';
import '../../Ads/ads_variable.dart';
import '../../Inapppurchase/credit/BIG_creditManager.dart';
import '../../Inapppurchase/credit/BIG_cut_credit.dart';
import '../../services/BIG_Permission.dart';
import '../BIG_Homepage.dart';

class BigAgeandgender extends StatefulWidget {
  const BigAgeandgender({super.key});

  @override
  State createState() => MyHomePageState();
}

class MyHomePageState extends State<BigAgeandgender> {
  late String _base64 = "";
  late String _age = "Waiting For Age...";
  late String _dominantGender = "Waiting For Gender...";
  final ImagePicker _picker = ImagePicker();
  late bool loading = false;
  ScreenshotController screenshotController2 = ScreenshotController();

  Uint8List? _imageFile;
  // GlobalKey _globalKey = GlobalKey();
  late Uint8List imageInMemory;
  late String imagePath;
  late File capturedFile;
  File? Imagessss;
  String? imagepath;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _cropImage() async {
    if (imagepath != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagepath!,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(
              width: 520,
              height: 520,
            ),
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          // Convert CroppedFile to File
          Imagessss = File(croppedFile.path);
          _compress();
        });
      }
    }
  }

  Future<void> _compress() async {
    final compressedImage = await _compressImage(Imagessss!);
    final base64Image = base64Encode(compressedImage);
    setState(() {
      _base64 = base64Image;
    });
    // Now send this base64 string to the API
    await _sendImageToServer(base64Image);
  }

  Future<void> _pickImage() async {
  await  BIG_MyPermissionHandler.checkPermission('gallery');
    try {
      XFile? image;

      // Check platform-specific behavior
      if (Platform.isAndroid) {
        // Android-specific image picking
        image = await _picker.pickImage(source: ImageSource.gallery);
      } else if (Platform.isIOS) {
        // iOS-specific image picking
        image = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (image != null) {
        setState(() {
          imagepath = image!.path.toString(); // Save image path
          _cropImage(); // Call crop function
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }


  Future<void> _pickImagecamera() async {
    // Pick image from the camera
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Set the image path
      setState(() {
        imagepath = image.path; // Update the path of the captured image
      });

      // Call the cropping method
      _cropImage();
    } else {
      // Handle the case where the image capture was canceled or failed
      print('No image selected.');
    }
  }

  Future<Uint8List> _compressImage(File image) async {
    final result = await FlutterImageCompress.compressWithFile(
      image.path,
      minWidth: 500,
      minHeight: 500,
      quality: 90, // Adjust quality as needed
      format: CompressFormat.jpeg,
    );
    return result!;
  }

  Future<void> _captureImage() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final Uint8List? image = await screenshotController2.capture();
        if (image != null) {
          setState(() {
            _imageFile = image;
            _saveToGallery(image);
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Save image Faild!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }
  }

  Future<void> _captureImage2() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final Uint8List? image = await screenshotController2.capture();
        if (image != null) {
          setState(() {
            _imageFile = image;
            _shareImage();
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Save image Faild!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }
  }

  Future<void> _saveToGallery(Uint8List image) async {
    try {
      final result = await ImageGallerySaver.saveImage(image,
          quality: 60, name: "processed_image_${DateTime.now()}");
      if (result['isSuccess']) {
        Fluttertoast.showToast(
          msg: 'Save image To Gallery!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Color(0xFF14e7e2),
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Save image Faild!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Color(0xFF14e7e2),
          fontSize: 16.0,
        );
        Fluttertoast.showToast(
          msg: 'Failed to save image.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Color(0xFF14e7e2),
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to save image.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );

    }
  }

  Future<void> _shareImage() async {
    if (_imageFile == null) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/processed_image.png');
      await file.writeAsBytes(_imageFile!);

      await Share.shareXFiles([XFile(file.path)],
          text: 'Here is the processed image!');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to share image.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }
  }

  Future<void> _sendImageToServer(String base64Image) async {

    BigCutCredit.cutCredit(AdsVariable.big_babyage_creditcut);
    //cut credit
    AdsLoadUtil.onShowAds(context, () {});
    setState(() {
      loading = true;
    });

    final url = Uri.parse(
        "https://age-detection-and-gender-detection-from-face-image.p.rapidapi.com/api/faces");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-rapidapi-host':
            'age-detection-and-gender-detection-from-face-image.p.rapidapi.com',
        // 'x-rapidapi-key': '5e70f4fc9emshd334e170e36833fp13f46bjsn7c053bd4b708',
        'x-rapidapi-key': Globals.agedetection,
      },
      body: jsonEncode({
        'base64_image': base64Image,
      }),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        final models = data['models'] as List<dynamic>;
        if (models.isNotEmpty) {
          final output = models[0]['output'] as List<dynamic>;
          if (output.isNotEmpty) {
            final firstOutput = output[0];
            // setState(() {
            //   _age = firstOutput['age'].toString();
            //   _dominantGender = firstOutput['dominant_gender'];
            // });
            if( loading == true){
              setState(() {
                loading = false;
              });
              AdsLoadUtil.onShowAds(context, () {
                Get.to(() => Ageandgenderresult(
                  base64: _base64,
                  Gender: firstOutput['dominant_gender'],
                  age: firstOutput['age'].toString(),
                ));
              });
            }

          }
        }
      } catch (e) {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
      BigCutCredit.addCredit(AdsVariable.big_babyage_creditcut);
      Fluttertoast.showToast(
        msg: "API credit Not Available. Please recharge!",
        toastLength: Toast.LENGTH_SHORT, // LENGTH_SHORT or LENGTH_LONG
        gravity: ToastGravity.BOTTOM, // Can be TOP, CENTER, or BOTTOM
        timeInSecForIosWeb: 1, // Toast duration for iOS and Web
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(loading == true){
             BIG_ImageUtils.showCloseConfirmationDialog(context, (){
               setState(() {
                 loading= false;
               });
             });
          }
          else{
            AdsLoadUtil.onShowAds(context, () {
              Get.back();
            });
          }
          return false;
        },
        child: loading == true
            ? Scaffold(
                backgroundColor: LightThemeColors.black,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 750.h,
                        width: 750.w,
                        child: Image.asset(
                          'assets/sc_9/generating.gif',
                          width: 1242.w,
                        ),
                      ),
                    ),
                  ],
                ))
            : Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  centerTitle: true,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BIG_PressUnpress(
                      onTap: () async {
                        AdsLoadUtil.onShowAds(context, () {
                          Get.back();
                        });
                      },
                      unPressColor: Colors.transparent,
                      height: 100.h,
                      width: 100.w,
                      imageAssetPress: 'assets/sc_6/back_press.png',
                      imageAssetUnPress: 'assets/sc_6/back_unpress.png',
                    ).marginOnly(left: 20.w),
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white, // Set the icon color to white
                  ),
                  backgroundColor: LightThemeColors.black,
                  title: Text(
                    'Age Detection',
                    style: TextStyle(
                        color: LightThemeColors.white, fontSize: 60.sp),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.only(left: 16.w,right: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Center(
                          child: Container(
                            height: 800.h,
                            width: 1100.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async{
                                    int userCredits = await BIG_CreditsManager.getUserCredits();
                                    if(userCredits >= AdsVariable.big_babyage_creditcut){
                                      _pickImage();
                                    }else{
                                      Fluttertoast.showToast(msg: "You dont't have any credit");
                                    }
                                  },
                                  child: Container(
                                    height: 230.h,
                                    width: 230.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/sc_11&12/plus.png'),
                                          fit: BoxFit.fill),
                                    ),
                                  ).marginOnly(bottom: 50.h),
                                ),
                                Container(
                                  height: 114.h,
                                  width: 612.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/sc_11&12/Pick Image from gallery & upload here.png'),
                                        fit: BoxFit.fill),
                                  ),
                                ).marginOnly(bottom: 50.h),
                                BIG_PressUnpress(
                                  onTap: () async {
                                    int userCredits = await BIG_CreditsManager.getUserCredits();
                                    if(userCredits >= AdsVariable.big_babyage_creditcut){
                                      _pickImage();
                                    }else{
                                      Fluttertoast.showToast(msg: "You dont't have any credit");
                                    }
                                  },
                                  unPressColor: Colors.transparent,
                                  height: 160.h,
                                  width: 720.w,
                                  imageAssetPress:
                                      'assets/sc_11&12/upload_press.png',
                                  imageAssetUnPress:
                                      'assets/sc_11&12/upload_unpress.png',
                                )
                              ],
                            ),
                          ).marginOnly(top: 150.h),
                        ),
                        Text(
                          _age,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF464646)),
                        ),
                        Text(
                          _dominantGender,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF464646)),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar:
                AdsVariable.isPurchase == false
                    ? (AdsVariable.big_babyage_bannerAd!= "11")
                    ? Container(
                  child: BannerAdWidget(
                      adId: AdsVariable.big_babyage_bannerAd),
                )
                    : Container()
                    : Container(),
        ));
  }
}

class Ageandgenderresult extends StatefulWidget {
  final String? base64;
  final String? age;
  final String? Gender;

  const Ageandgenderresult({
    super.key,
    required this.base64,
    required this.Gender,
    this.age,
  });

  @override
  State<Ageandgenderresult> createState() => _AgeandgenderresultState();
}

class _AgeandgenderresultState extends State<Ageandgenderresult> {
  // Create a ScreenshotController instance
  final ScreenshotController screenshotController = ScreenshotController();

  // Function to capture and save image to the gallery
  Future<void> saveImage() async {
    BIG_ImageUtils.showLoadingDialog(context);

    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final result = await ImageGallerySaver.saveImage(
          image,
          quality: 100,
          name: "age_and_gender_result",
        );
        BIG_ImageUtils.hideLoadingDialog(context);
        Fluttertoast.showToast(
          msg: 'Image saved to gallery!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Color(0xFF14e7e2),
          fontSize: 16.0,
        );
      }
    }).catchError((onError) {
      BIG_ImageUtils.hideLoadingDialog(context);
      print(onError);
      Fluttertoast.showToast(
        msg: 'Failed to save image!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    });
  }

  // Function to capture and share image
  Future<void> shareImage() async {
    BIG_ImageUtils.showLoadingDialog(context);
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        print("ssss");
        // Get the temporary directory
        final tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        // Save the image to the temp file
        File file = await File('$tempPath/age_and_gender_result.png')
            .writeAsBytes(image);

        // Share the image using share_plus
        await Share.shareXFiles([XFile(file.path)], text: 'Great picture');
        BIG_ImageUtils.hideLoadingDialog(context);
      }
    }).catchError((onError) {
      print(onError);
      BIG_ImageUtils.hideLoadingDialog(context);
      Fluttertoast.showToast(
        msg: 'Failed to share image!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String? base64 = widget.base64;
    String? gender = widget.Gender;
    String? age = widget.age;

    return WillPopScope(
      onWillPop: () async {
        AdsLoadUtil.onShowAds(context, () {
          // Get.back();
          Get.offAll(() => BIG_Homepage());
        });
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BIG_PressUnpress(
              onTap: () async {
                AdsLoadUtil.onShowAds(context, () {
                  Get.offAll(() => BIG_Homepage());
                  // Get.back();
                });
              },
              unPressColor: Colors.transparent,
              height: 100.h,
              width: 100.w,
              imageAssetPress: 'assets/sc_6/back_press.png',
              imageAssetUnPress: 'assets/sc_6/back_unpress.png',
            ).marginOnly(left: 20.w),
          ),
          title: Text(
            "Age Detection",
            style: TextStyle(fontSize: 60.sp, color: Colors.white),
          ),
        ),
        body: Container(
          height: 2208.h,
          width: 1242.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sc_6/bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Wrap the part to be captured in Screenshot widget
                SizedBox(height: 70.h,),
                Screenshot(
                  controller: screenshotController,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          width: 1100.w,
                          height: 800.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Image.memory(
                            base64Decode(base64!),
                            fit: BoxFit.cover,
                            height: 250,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Text(
                        'Age : ${age}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ).marginOnly(top: 150.h, bottom: 15.h),
                      Text(
                        'Dominant Gender : ${gender}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ).marginOnly(bottom: 200.h),
                    ],
                  ),
                ),
                BIG_PressUnpress(
                  onTap: () async {
                    saveImage();
                  },
                  unPressColor: Colors.transparent,
                  height: 200.h,
                  width: 1100.w,
                  imageAssetPress: 'assets/sc_19/save_image_press.png',
                  imageAssetUnPress: 'assets/sc_19/save_image_unpress.png',
                ).marginOnly(bottom: 20.h),
                BIG_PressUnpress(
                  onTap: () async {
                    shareImage();
                  },
                  unPressColor: Colors.transparent,
                  height: 200.h,
                  width: 1100.w,
                  imageAssetPress: 'assets/sc_19/share_image_press.png',
                  imageAssetUnPress: 'assets/sc_19/share_image_unpress.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
