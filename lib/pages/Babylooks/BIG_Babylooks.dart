import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/const/global/globalapi.dart';
import 'package:babyimage/pages/Babygenerator/BIG_Babyimagegeneratorapi.dart';
import 'package:babyimage/pages/BIG_Homepage.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:babyimage/utils/BIG_ImageUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../Ads/Bannerads.dart';
import '../../Ads/ads_load_util.dart';
import '../../Ads/ads_variable.dart';
import '../../Inapppurchase/credit/BIG_creditManager.dart';
import '../../Inapppurchase/credit/BIG_cut_credit.dart';
import '../../services/BIG_Permission.dart';

class BIG_BabyLooks extends StatefulWidget {
  const BIG_BabyLooks({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<BIG_BabyLooks> {
  String _base64Image = '';
  bool _isLoading = false;
  Uint8List? _imageBytes;
  late int _selectedAge = 20; // Default to age 1
  late bool errortext = false;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _globalKey = GlobalKey();
  late String imagePath;
  late File capturedFile;
  String? imagespath;
  String? imagespathselect;

  ScreenshotController screenshotController = ScreenshotController();


  Future<void> _pickImage() async {
    try {
     await BIG_MyPermissionHandler.checkPermission('gallery');
      XFile? pickedFile;

      // Use different logic for Android and iOS if needed
      if (Platform.isAndroid) {
        // Android-specific code for picking an image from the gallery
        pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      } else if (Platform.isIOS) {
        // iOS-specific code for picking an image from the gallery
        pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedFile != null) {
        // Perform platform-specific actions if needed before cropping
        setState(() {
          imagespathselect = pickedFile!.path; // Save image path
        });

        // Optionally crop image (applies to both platforms)
        _cropImagefather(); // Your cropping function
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }


  Future<void> _cropImagefather() async {
    if (imagespathselect != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagespathselect!,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 40,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
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
          imagespath = croppedFile.path;
        });
      }
    }
  }

  Future<void> _compressAndUploadImage(File image) async {
    setState(() {
      _isLoading = true;
    });

    final compressedImage = await FlutterImageCompress.compressWithFile(
      image.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 90,
      format: CompressFormat.jpeg,
    );

    if (compressedImage != null) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.jpg');
      tempFile.writeAsBytesSync(compressedImage);
      // setState(() {
      //   _isLoading =false;
      // });
      _uploadImage(tempFile);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    final age = _selectedAge.toInt().toString();
    final uri = Uri.parse(
        'https://www.ailabapi.com/api/portrait/effects/face-attribute-editing');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Content-Type'] = 'multipart/form-data'
      // ..headers['ailabapi-api-key'] = 'C8F9PKBDz1Yxe4platLnc0CykbSXO2O6hgsz7Wyt5pTjmGsQJVrJ5PTunq6YoMEE'
      ..headers['ailabapi-api-key'] = Globals.babyllok
      ..files.add(await http.MultipartFile.fromPath('image', image.path))
      ..fields['action_type'] = 'V2_AGE'
      ..fields['target'] = age
      ..fields['quality_control'] = 'HIGH';

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);
      if (responseJson['error_code'] == 0) {
        final base64Image = responseJson['result']['image'];
        final imageBytes = base64Decode(base64Image);

        if(_isLoading == true){
          setState(() {
            _base64Image = base64Image;
            _imageBytes = imageBytes;
            _isLoading = false;
          });
          AdsLoadUtil.onShowAds(context, (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  imageBytes: _imageBytes,
                  base64Image: _base64Image,
                  parentContext: context, // Pass the BuildContext here
                  globalKey: _globalKey, // Pass the GlobalKey here
                  imagespath: imagespath!, // Pass the GlobalKey here
                ),
              ),
            );
          });
        }
      } else {

        responseJson['error_code'] == 422 ? null:
        // Fluttertoast.showToast(
        //   msg: "API credit Not Available. Please recharge!",
        //   toastLength: Toast.LENGTH_SHORT, // LENGTH_SHORT or LENGTH_LONG
        //   gravity: ToastGravity.BOTTOM,    // Can be TOP, CENTER, or BOTTOM
        //   timeInSecForIosWeb: 1,           // Toast duration for iOS and Web
        //   backgroundColor: Colors.black,
        //   textColor:  Color(0xFF14e7e2),
        //   fontSize: 16.0,
        // );
        setState(() {
          _isLoading = false;
          _imageBytes = null;
        });
      }
      if (responseJson['error_code'] == 422) {
        setState(() {
          _isLoading = false;
        });
        // Fluttertoast.showToast(
        //   msg: 'Please Upload Perfect Image!',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.black,
        //   textColor: Color(0xFF14e7e2),
        //   fontSize: 16.0,
        // );
        throw Exception("");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Please Upload Perfect Image!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
      BigCutCredit.addCredit(AdsVariable.big_babylook_creditcut);
      setState(() {
        _isLoading = false;
        _imageBytes = null;
      });
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_isLoading == true){
          BIG_ImageUtils.showCloseConfirmationDialog(context, (){ setState(() {
            _isLoading = false;
          });});
        }else{
          if (imagespath == null) {
            AdsLoadUtil.onShowAds(context, () {
              Get.back();
            });
          } else {
            print("back");
          }

          setState(() {
            imagespath = null;  // Assign the value instead of just comparing
          });
        }

        return false;
      },
      child:  _isLoading == true ? Scaffold(
        backgroundColor: Colors.black,
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 750.h,
                width: 750.w,
                child: Image.asset('assets/sc_9/generating.gif',width: 1242.w,),
              ),
            ),
          ],
        ),
      ):  Scaffold(
        backgroundColor: LightThemeColors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
          leading: Padding(
              padding: EdgeInsets.all(12),
              child: BIG_PressUnpress(
                onTap: () async{
                  if (imagespath == null) {
                    AdsLoadUtil.onShowAds(context, () {
                      Get.back();
                    });
                  } else {
                    AdsLoadUtil.onShowAds(context, () {
                      setState(() {
                        imagespath = null;  // Assign the value instead of just comparing
                      });
                    });
                    print("back");
                  }

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
            "Baby Looks",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Container(
                  height: 2208.h,
                  width: 1242.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/sc_6/bg.png'), fit: BoxFit.fill),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        imagespath == null
                            ? Container(
                                height: 800.h,
                                width: 1100.w,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 230.h,
                                      width: 230.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/sc_11&12/plus.png'),
                                            fit: BoxFit.fill),
                                      ),
                                    ).marginOnly(bottom: 50.h,top: 50.h),
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
                                        _pickImage();
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
                              ).marginOnly(top: 50.h)
                            : GestureDetector(
                              child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                  child: Image.file(
                                    height: 700.h,
                                    width: 1100.w,
                                    File(imagespath!), // Convert the path to a File
                                    fit: BoxFit.cover, // Adjust this to your needs
                                  ),
                                ).marginOnly(top: 50.h, bottom: 80.h),
                            ),
                        Text(
                          'Select Age: ${_selectedAge}',
                          style: const TextStyle(
                              fontSize: 18,
                              color: LightThemeColors.white,
                              fontWeight: FontWeight.w500),
                        ).marginOnly(bottom: 80.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            NumberPicker(
                              itemCount: 9,
                              itemWidth: 100.h,
                              textStyle: TextStyle(color: Color(0XFF353535),fontSize: 20),
                              selectedTextStyle:  TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 26),
                              axis: Axis.horizontal,
                              value: _selectedAge,
                              minValue: 1,
                              maxValue: 85,
                              onChanged: (value){
                                setState(() {
                                  _selectedAge =value;
                                });
                              },
                            ),
                          ],
                        ),
                        Center(
                          child:
                          Container(
                            height: 65.h,
                            width: 87.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/sc_11&12/pointer.png'), fit: BoxFit.fill),
                            ),),
                        ),

                        // Slider(
                        //   value: _selectedAge,
                        //   min: 1,
                        //   max: 85,
                        //   divisions: 84,
                        //   label: _selectedAge.toInt().toString(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _selectedAge = value;
                        //     });
                        //   },
                        // ).marginSymmetric(horizontal: 20),
                        Spacer(),
                        BIG_PressUnpress(
                          onTap: () async {
                            if (imagespath == null) {
                              Fluttertoast.showToast(
                                msg: 'Please Upload Image First!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Color(0xFF14e7e2),
                                fontSize: 16.0,
                              );
                            } else {
                              int userCredits = await BIG_CreditsManager.getUserCredits();
                              if(userCredits >= AdsVariable.big_babylook_creditcut){
                                //cut credit
                                AdsLoadUtil.onShowAds(context, (){
                                  BigCutCredit.cutCredit(AdsVariable.big_babylook_creditcut);
                                  _compressAndUploadImage(File(imagespath!));
                                });
                              }else{
                                Fluttertoast.showToast(msg: "You dont't have any credit");
                              }
                            }
                          },
                          unPressColor: Colors.transparent,
                          height: 180.h,
                          width: 950.w,
                          imageAssetPress: 'assets/sc_11&12/generate_press.png',
                          imageAssetUnPress: 'assets/sc_11&12/generate_unpress.png',
                        ).marginOnly(top: 80.h),
                        // imagespath != null
                        //     ? ClipRRect(
                        //         borderRadius:
                        //             const BorderRadius.all(Radius.circular(30)),
                        //         child: Image.file(
                        //           height: 200,
                        //           width: 200,
                        //           File(imagespath!), // Convert the path to a File
                        //           fit: BoxFit.cover, // Adjust this to your needs
                        //         ),
                        //       ).marginOnly(bottom: 30)
                        //     : const SizedBox.shrink(),
                        // GestureDetector(
                        //   onTap: _Showmodel,
                        //   child: Container(
                        //     height: 50,
                        //     margin: const EdgeInsets.symmetric(horizontal: 50),
                        //     decoration: BoxDecoration(
                        //       color: LightThemeColors.white,
                        //       borderRadius: BorderRadius.circular(
                        //           50), // Apply same radius for consistency
                        //     ),
                        //     alignment: Alignment.center,
                        //     child: const Text(
                        //       'Pickup and uploadss',
                        //       style: TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),

                        // GestureDetector(
                        //   onTap: () {
                        //     if (imagespath == null) {
                        //       Get.snackbar(
                        //         'Error',
                        //         'Please Upload Image First!',
                        //         snackPosition: SnackPosition.BOTTOM,
                        //         backgroundColor: Colors.red,
                        //         colorText: Colors.white,
                        //       );
                        //     } else {
                        //       _compressAndUploadImage(File(imagespath!));
                        //     }
                        //   },
                        //   child: Container(
                        //     height: 50,
                        //     margin: const EdgeInsets.symmetric(horizontal: 50),
                        //     decoration: BoxDecoration(
                        //       color: LightThemeColors.white,
                        //       borderRadius: BorderRadius.circular(
                        //           50), // Apply same radius for consistency
                        //     ),
                        //     alignment: Alignment.center,
                        //     child: const Text(
                        //       'Generate Image',
                        //       style: TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ).marginOnly(top: 20),
                        // _isLoading == true
                        //     ? const CircularProgressIndicator(
                        //         color: Colors.white,
                        //       ).marginOnly(top: 20, bottom: 20)
                        //     : const SizedBox.shrink(),
                        // const SizedBox(height: 20),

                        const SizedBox(height: 20),
                        // errortext
                        //     ? const Text(
                        //         "Image is not perfect. Please add a perfect image.",
                        //         textAlign: TextAlign.center,
                        //         style: TextStyle(color: LightThemeColors.white),
                        //       ).marginSymmetric(horizontal: 20)
                        //     : const SizedBox.shrink(),
                        Spacer(),
                        AdsVariable.isPurchase == false
                            ? (AdsVariable.big_babylook_bannerAd!= "11")
                            ? Container(
                          child: BannerAdWidget(
                              adId: AdsVariable.big_babylook_bannerAd),
                        )
                            : Container()
                            : Container(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final Uint8List? imageBytes;
  final String base64Image;
  final BuildContext parentContext;
  final GlobalKey globalKey;
  late String? imagespath;

  ResultScreen({
    super.key,
    required this.imageBytes,
    required this.base64Image,
    required this.parentContext,
    required this.globalKey,
    required this.imagespath,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double? value = 0.5;


  Future<void> _shareImage(BuildContext context) async {
    if (widget.imageBytes == null) return;

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/processed_image.png');
      await file.writeAsBytes(widget.imageBytes!);

      await Share.shareXFiles([XFile(file.path)],
          text: 'Here is the processed image!');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to share image!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        AdsLoadUtil.onShowAds(context, (){
          // print("willpopcall");
          // Get.back();
          Get.offAll(() => BIG_Homepage());
        });

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
          leading: Padding(
              padding: EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  AdsLoadUtil.onShowAds(context, (){
                    // print("willpopcall2");
                    // Get.back();
                    Get.offAll(() => BIG_Homepage());
                  });
                },
                child: Image.asset('assets/sc_6/back_unpress.png'),
              )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Baby Look",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (widget.imageBytes != null)
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.memory(
                    widget.imageBytes!,
                    height: 1300.h,
                    width: 1100.w,
                    fit: BoxFit.cover,
                  ),
                ).marginOnly(top: 30.h),

              BIG_PressUnpress(
                onTap: () {
                    BIG_ImageUtils.saveImageToGalleryBytes(widget.imageBytes!);
                },
                unPressColor: Colors.transparent,
                height: 200.h,
                width: 1100.w,
                imageAssetPress: 'assets/sc_13/save_image_press.png',
                imageAssetUnPress: 'assets/sc_13/save_image_unpress.png',
              ).marginOnly(top: 70.h),
              BIG_PressUnpress(
                onTap: () {
                    BIG_ImageUtils.shareImageBytes(widget.imageBytes!);
                },
                unPressColor: Colors.transparent,
                height: 200.h,
                width: 1100.w,
                imageAssetPress: 'assets/sc_13/share_image_press.png',
                imageAssetUnPress: 'assets/sc_13/share_image_unpress.png',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
