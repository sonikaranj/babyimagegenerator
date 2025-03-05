import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:babyimage/Inapppurchase/credit/BIG_cut_credit.dart';
import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/const/global/globalapi.dart';
import 'package:babyimage/pages/Babygenerator/BIG_BabyImageresult.dart';
import 'package:babyimage/pages/Babygenerator/BIG_ImagePickupscreen.dart';
import 'package:babyimage/services/BIG_Permission.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:babyimage/utils/BIG_ImageUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../Ads/Bannerads.dart';
import '../../Ads/ads_load_util.dart';
import '../../Ads/ads_variable.dart';
import '../../Inapppurchase/credit/BIG_creditManager.dart';

class BIG_BabyGeneratorScreen extends StatefulWidget {
  const BIG_BabyGeneratorScreen({super.key});

  @override
  _BIG_BabyGeneratorScreenState createState() => _BIG_BabyGeneratorScreenState();
}

class _BIG_BabyGeneratorScreenState extends State<BIG_BabyGeneratorScreen> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;
  String adId = AdsVariable.big_babygenerator_bannerAd;

  bool failedToLoad = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _currentOrientation = MediaQuery.of(context).orientation;
      _loadAd();
    });

    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadAd() async {
    print("taishq madarchod lauda he ");
    await _anchoredAdaptiveAd?.dispose();
    setState(() {
      _anchoredAdaptiveAd = null;
      _isLoaded = false;
    });
    print("tttttt");

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: adId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          setState(() {
            failedToLoad = true;
          });
          ad.dispose();
        },
      ),
    );
    print(_anchoredAdaptiveAd);
    print("ssssssss");
    return _anchoredAdaptiveAd!.load();
  }

  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          return Container(
            color: Colors.transparent,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          );
        }
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container(
          height: MediaQuery.of(context).size.height / 13.5,
          width: double.infinity,
        );
      },
    );
  }

  Widget _getBannerLoaderAd() {
    print("INtro Banner Ad is ${adId}");
    if (adId == "11") {
      return Container(
        height: 0,
      );
    } else {
      if (_isLoaded) {
        return _getAdWidget();
      } else {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 13.5,
          width: double.infinity,
          child: Shimmer.fromColors(
            direction: ShimmerDirection.ttb,
            enabled: true,
            // baseColor: shimmerAdBaseColor,
            baseColor: Colors.red,
            // Light grey
            // highlightColor: shimmerAdHighlightColor,
            highlightColor: Colors.red,
            // Even lighter grey
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 13.5,
              color: Colors.grey,
              child: Container(),
              // Set the color of the container
            ),
          ),
        );
      }
    }
  }

  bool? isLoadingsc = false;
  bool? genderofimage = true;
  ScreenshotController screenshotController = ScreenshotController();
  File? _motherImage;
  File? _fatherImage;
  String? _motherImageUrl;
  String? _fatherImageUrl;
  final picker = ImagePicker();
  final String apiKey = Globals.babygenerator;
  final String apiHost = 'baby-generator-ai.p.rapidapi.com';
  String generatedImage = '';
  bool isLoading = false;
  final GlobalKey _globalKey = GlobalKey();
  late Uint8List imageInMemory;
  late String imagePath;
  late File capturedFile;
  bool? isloading = false;



  Future<void> shareImage(Uint8List? imageBytes) async {
    if (imageBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image.png');
    await file.writeAsBytes(imageBytes);
  }

  Future<void> _captureImage2() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/screenshot.png');
        await file.writeAsBytes(image);

        // Save to gallery
        await ImageGallerySaver.saveImage(image,
            quality: 60, name: "screenshot");
        Fluttertoast.showToast(
          msg: 'Image save successful!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Color(0xFF14e7e2),
          fontSize: 16.0,
        );
        // Share the screenshot
        // await Share.shareXFiles([XFile(file.path)], text: 'Here is the screenshot!');
      }
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

  Future<void> Shareimage() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/screenshot.png');
        await file.writeAsBytes(image);

        // Save to gallery
        await Share.shareXFiles([XFile(file.path)],
            text: 'Here is the processed image!');

        // Share the screenshot
        // await Share.shareXFiles([XFile(file.path)], text: 'Here is the screenshot!');
      }
    } catch (e) {

      Fluttertoast.showToast(
        msg: 'Share image Faild!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }
  }

  Future<void> _uploadImage(File image, bool isMother) async {
    final bytes = await image.readAsBytes();
    final file = http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: image.path.split('/').last,
      contentType: MediaType('image', 'jpeg'),
    );

    final url = Uri.parse('https://www.imghippo.com/v1/upload');
    var request = http.MultipartRequest('POST', url)
      ..fields['api_key'] = 'L6ZEc2HKM10WRP0ICteJo4MsFUwO9jAE'
      ..files.add(file);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      setState(() {
        if (jsonResponse['success'] == true) {
          if (isMother) {
            _motherImageUrl = jsonResponse['data']['view_url'];
          } else {
            _fatherImageUrl = jsonResponse['data']['view_url'];
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Upload failed!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Color(0xFF14e7e2),
            fontSize: 16.0,
          );
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Upload failed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }
  }

  Future<void> _generateBaby(bool boys) async {
    // setState(() {
    //   isLoading = true;
    // });
    try{
      if (_motherImageUrl == null || _fatherImageUrl == null) {
        await _uploadImage(_motherImage!, false);
        await _uploadImage(_fatherImage!, true);
      }

      final uri = Uri.https(apiHost, '/footprint_api/web/blend');
      final payload = jsonEncode({
        'item_id': boys ? '0F8Ke0fpWk4uFhwu6blS' : 'ZjcoJww4QgrpqmRBRGZ8',
        'input_image_urls': [_motherImageUrl, _fatherImageUrl],
      });
      print(_motherImageUrl);
      print(_fatherImageUrl);

      final response = await http.post(
        uri,
        headers: {
          'x-rapidapi-key': apiKey,
          'x-rapidapi-host': apiHost,
          'Content-Type': 'application/json',
        },
        body: payload,
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if( isLoadingsc == true){
          setState(() {
            isLoadingsc = false;
            generatedImage = responseBody['blend']['result_image_url'];
          });
          Get.to(() => BIG_Babyimageresult(imageurl: generatedImage));
          // AdsLoadUtil.onShowAds(context, () {
          //   Get.to(() => Babyimageresult(imageurl: generatedImage));
          // });
        }
        // setState(() {
        //   isLoadingsc = false;
        // });
      } else {
        setState(() {
          isLoadingsc = false;
        });
        throw Exception('Failed to load data');
      }
    }catch(e){
      BigCutCredit.addCredit(AdsVariable.big_babygenerator_creditcut);
      Fluttertoast.showToast(
        msg: 'Failed to generate baby Image!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }

  }

  bool _isPressed = false;
  bool _isPressed2 = false;
  void _handleTap(bool isPressed) async {
    setState(() {
      _isPressed = isPressed;
    });
    var result = await Get.to(() => BIG_Imagepickupscreen(
          fatherimage: true,
        ));
    if (result != null) {
      setState(() {
        _motherImage = result;
      });
    }
    // await _uploadImage(_motherImage!, false);
  }

  void _resetTap() {
    _handleTap(false);
  }

  void _handleTap2(bool isPressed) async {
    setState(() {
      _isPressed2 = isPressed;
    });
    var result = await Get.to(() => BIG_Imagepickupscreen(
          fatherimage: false,
        ));
    print(result);
    if (result != null) {
      setState(() {
        _fatherImage = result;
      });
    }
    // await _uploadImage(_fatherImage!, true);
  }

  void _resetTap2() {
    _handleTap2(false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingsc == false
        ? WillPopScope(
            onWillPop: () async {
              AdsLoadUtil.onShowAds(context, () {
                Get.back();
              });
              return false;
            },
            child: Scaffold(
              backgroundColor: LightThemeColors.black,
              appBar: AppBar(
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Colors.white, // Set the icon color to white
                ),
                backgroundColor: LightThemeColors.black,
                leading: Padding(
                    padding: EdgeInsets.all(12),
                    child: BIG_PressUnpress(
                      onTap: () {
                        AdsLoadUtil.onShowAds(context, () {
                          Get.back();
                        });
                      },
                      unPressColor: Colors.transparent,
                      height: 100.h,
                      width: 100.w,
                      imageAssetPress: 'assets/sc_6/back_press.png',
                      imageAssetUnPress: 'assets/sc_8/back_unpress.png',
                    )),
                title: Text(
                  'Baby Generator',
                  style:
                      TextStyle(color: LightThemeColors.white, fontSize: 70.sp),
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 70.w,vertical: 30.h),
                  child: Screenshot(
                    controller: screenshotController,
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  height: 39.h,
                                  width: 475.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/sc_6/Add Parents ‘s Photo.png'))),
                                ),
                              ],
                            ).marginOnly(top: 40.h, bottom: 20.h),
                            Container(
                              height: 570.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTapDown: (_) => _handleTap(true),
                                    onTapUp: (_) => _handleTap(false),
                                    onTapCancel: _resetTap,
                                    child: Container(
                                      height: 570.h,
                                      width: 510.w,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/sc_6/button_bg.png'))),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          _motherImage == null
                                              ? Container(
                                                  height: 310.h,
                                                  width: 289.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/sc_6/dad_logo.png'))),
                                                )
                                              : Container(
                                                  height: 289.w,
                                                  width: 289.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/sc_6/image_bg.png'))),
                                                  child: ClipOval(
                                                    child: Image.file(
                                                        _motherImage!,
                                                        width: 289.w,
                                                        height: 289.w,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ).marginOnly(bottom: 30.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: 90.h,
                                                width: 233.w,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/sc_6/Upload Dad’s Photo.png'))),
                                              ),
                                              Container(
                                                height: 90.h,
                                                width: 90.w,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(_isPressed
                                                            ? 'assets/sc_6/plus_press.png'
                                                            : 'assets/sc_6/plus_unpress.png'))),
                                              ),
                                            ],
                                          ).marginOnly(bottom: 90.h)
                                        ],
                                      ),
                                    ),
                                  ).marginOnly(right: 20.w),
                                  GestureDetector(
                                    onTapDown: (_) => _handleTap2(true),
                                    onTapUp: (_) => _handleTap2(false),
                                    onTapCancel: _resetTap2,
                                    child: Container(
                                      height: 570.h,
                                      width: 510.w,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/sc_6/button_bg.png'))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _fatherImage == null
                                              ? Container(
                                                  height: 310.h,
                                                  width: 289.w,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/sc_6/mom_logo.png'))),
                                                )
                                              : Container(
                                                  height: 289.w,
                                                  width: 289.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/sc_6/image_bg.png'))),
                                                  child: ClipOval(
                                                    child: Image.file(
                                                        _fatherImage!,
                                                        width: 289.w,
                                                        height: 289.w,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ).marginOnly(bottom: 30.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height: 90.h,
                                                width: 233.w,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/sc_6/Upload Mom’s Photo.png'))),
                                              ),
                                              Container(
                                                height: 90.h,
                                                width: 90.w,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(_isPressed2
                                                            ? 'assets/sc_6/plus_2_press.png'
                                                            : 'assets/sc_6/plus_2_unpress.png'))),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 50.h,
                                  width: 606.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/sc_6/What’s your baby gender _.png'))),
                                ),
                              ],
                            ).marginOnly(top: 50.h, bottom: 70.h),
                            GestureDetector(

                              onTap: () {
                                print("baby boy");
                                setState(() {
                                  genderofimage = true;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 200.h,
                                    width: 1000.w,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/sc_6/baby boy.png'))),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("ssss");
                                    setState(() {
                                      genderofimage = false;
                                    });
                                  },
                                  child: Container(
                                    height: 200.h,
                                    width: 1000.w,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/sc_6/baby girl.png'))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Container(
                                        //   height: 60.h,
                                        //   width: 60.h,
                                        //   decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(50)),
                                        //       border: Border.all(
                                        //           width: 3,
                                        //           color: Color(0xFF2B2B2B))),
                                        // ).marginOnly(right: 50.w)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 100.h),
                            // isLoading
                            //     ? const CircularProgressIndicator().marginOnly(top: 20)
                            //     : generatedImage.isEmpty
                            //         ? const SizedBox.shrink()
                            //         : ClipRRect(
                            //             borderRadius:
                            //                 const BorderRadius.all(Radius.circular(30)),
                            //             child: CachedNetworkImage(
                            //               imageUrl: generatedImage,
                            //               height: 300,
                            //               width: 220,
                            //               placeholder: (context, url) =>
                            //                   const CircularProgressIndicator(),
                            //               errorWidget: (context, url, error) =>
                            //                   const Icon(Icons.error),
                            //             ),
                            //           ),
                            BIG_PressUnpress(
                              onTap: () async{
                                print("karan");
                                print(_motherImage);
                                print(_fatherImage);
                                if( _motherImage == null  || _fatherImage == null){
                                  print(_motherImage);
                                  print(_fatherImageUrl);

                                  Fluttertoast.showToast(
                                    msg: 'Please Pickup Image',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Color(0xFF14e7e2),
                                    fontSize: 16.0,
                                  );
                                }else{
                                    int userCredits = await BIG_CreditsManager.getUserCredits();
                                    if(userCredits >= AdsVariable.big_babygenerator_creditcut){
                                      AdsLoadUtil.onShowAds(context, () {
                                        setState(() {
                                          isLoadingsc = true;
                                        });
                                        BigCutCredit.cutCredit(AdsVariable.big_babygenerator_creditcut);
                                        _generateBaby(genderofimage!);
                                      });
                                    }else{
                                      Fluttertoast.showToast(msg: "You dont't have any credit");
                                    }
                                }
                              },
                              height: 180.h,
                              width: 950.w,
                              imageAssetPress: 'assets/sc_8/generate_press.png',
                              imageAssetUnPress:
                                  'assets/sc_8/generate_unpress.png',
                            ).marginOnly(top: 40),
                            // isloading == false
                            //     ? const SizedBox.shrink()
                            //     : const CircularProgressIndicator(
                            //         color: LightThemeColors.white,
                            //       ).marginOnly(top: 20),
                            // const SizedBox(
                            //   height: 30,
                            // ),
                            // generatedImage.isEmpty
                            //     ? const SizedBox.shrink()
                            //     : Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //           GestureDetector(
                            //             onTap: _captureImage2,
                            //             child: Container(
                            //               height: 50,
                            //               padding: const EdgeInsets.symmetric(
                            //                   horizontal: 15),
                            //               decoration: BoxDecoration(
                            //                 color: LightThemeColors.white,
                            //                 borderRadius: BorderRadius.circular(50),
                            //               ),
                            //               alignment: Alignment.center,
                            //               child: const Text(
                            //                 'Save Image',
                            //                 style: TextStyle(
                            //                     fontSize: 15,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             ),
                            //           ).marginOnly(right: 20),
                            //           GestureDetector(
                            //             onTap: Shareimage,
                            //             child: Container(
                            //               height: 50,
                            //               padding: const EdgeInsets.symmetric(
                            //                   horizontal: 15),
                            //               decoration: BoxDecoration(
                            //                 color: LightThemeColors.white,
                            //                 borderRadius: BorderRadius.circular(
                            //                     50), // Apply same radius for consistency
                            //               ),
                            //               alignment: Alignment.center,
                            //               child: const Text(
                            //                 'Share Image',
                            //                 style: TextStyle(
                            //                     fontSize: 18,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             ),
                            //           ),
                            //
                            //         ],
                            //       ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar:
              AdsVariable.isPurchase == false
                  ? (AdsVariable.big_babygenerator_bannerAd != "11")
                      ? Container(
                          child: BannerAdWidget(
                              adId: AdsVariable.big_babygenerator_bannerAd),
                        )
                      : Container()
                  : Container(),
              // AdsVariable.isPurchase == false
              //     ? (AdsVariable.big_babygenerator_bannerAd != "11")
              //     ? Container(
              //   child: BannerAdWidget(
              //       adId: AdsVariable.big_babygenerator_bannerAd),
              // )
              //     : Container()
              //     : (AdsVariable.big_babygenerator_bannerAd != "11")
              //     ? Container(
              //   child: BannerAdWidget(
              //       adId: AdsVariable.big_babygenerator_bannerAd),
              // )
              //     : Container()
            ),
          )
        : WillPopScope(
          onWillPop: () async {
            BIG_ImageUtils.showCloseConfirmationDialog(context, (){
              setState(() {
                isLoadingsc = false;
              });
            });
            return false;
          },
          child: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/sc_6/bg.png'),
                        fit: BoxFit.fill)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/sc_9/generating.gif',
                          width: 750.w,
                          height: 750.h,
                        ),
                      ).marginOnly(bottom: 20.h),
                      Container(
                        width: 808.w,
                        height: 137.h,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/sc_9/Analyzing images & generating baby for you.png'),
                                fit: BoxFit.fill)),
                      )
                    ],
                  ),
                ),
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

class BlurOnLoadImage extends StatelessWidget {
  final String imageUrl;

  const BlurOnLoadImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => _buildBlurredPlaceholder(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fadeInDuration: const Duration(milliseconds: 500),
          fadeOutDuration: const Duration(milliseconds: 500),
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildBlurredPlaceholder() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.grey.shade300,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
      ],
    );
  }
}
