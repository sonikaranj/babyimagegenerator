import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/const/global/globalapi.dart';
import 'package:babyimage/pages/Babygenerator/BIG_Babyimagegeneratorapi.dart';
import 'package:babyimage/pages/BIG_imagetourl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../utils/BIG_ImageUtils.dart';

class BIG_Celebrityfind extends StatefulWidget {
  @override
  _ImagetourlState createState() => _ImagetourlState();
}

class _ImagetourlState extends State<BIG_Celebrityfind> {
  String _response1 = '';
  String _viewUrl1 = '';
  String _response2 = '';
  String _viewUrl2 = '';
  String _verificationResult = '';
  bool _isLoading = false;
  bool _loading = false;
  bool _result = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _image1;
  XFile? _image2;
  Uint8List? _imageFile;
  GlobalKey _globalKey = GlobalKey();
  late String imagePath;
  late File capturedFile;
  String? image1url;
  String? Name = "";
  ScreenshotController screenshotController = ScreenshotController();
  var imgaebase64;
  var nameofcelebrity;
  var group;
  Future<void> _pickAndUploadImage1() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image1 = image;
        _isLoading = true;
      });

      final bytes = await image.readAsBytes();
      final file = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
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
            _viewUrl1 = jsonResponse['data']['view_url'];
          } else {
            _response1 = 'Upload failed: ${jsonResponse['message']}';
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _response1 = 'Error: $e';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _response1 = 'No image selected.';
      });
    }
  }

  Future<void> _Showmodel()async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: double.infinity,
          color:LightThemeColors.textSecondary2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Pick Image",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: LightThemeColors.white),).marginOnly(top: 20)
                ],
              ).marginOnly(bottom: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap:(){
                      Get.back();
                      _pickAndUploadImage2camera();
                      // _generateBaby(false);
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: LightThemeColors.white,
                        borderRadius: BorderRadius.circular(50), // Apply same radius for consistency
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Camera',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ).marginOnly(right: 20),
                  GestureDetector(
                    onTap:(){
                      Get.back();
                      _pickAndUploadImage2();
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: LightThemeColors.white,
                        borderRadius: BorderRadius.circular(50), // Apply same radius for consistency
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Photos',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadImage2() async {
    await  BIG_ImageUtils.requestPermissions();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    _cropimage(image!);
  }

  Future<void> _pickAndUploadImage2camera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _cropimage(image);
    }
  }
  Future<void>_cropimage(XFile image )async{
    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
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
          _image1 = XFile(croppedFile.path);
          Imagetourl(_image1!);
        });
      }
    }

  }

  Future<void> Imagetourl(XFile image) async {
    if (image != null) {
      setState(() {
        _image2 = image;
        _isLoading = true;
      });

      final bytes = await image.readAsBytes();
      final file = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
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
            _viewUrl2 = jsonResponse['data']['view_url'];
            print(_viewUrl2);
            if (image1url != null) {
              _verifyFaces();
            }
          } else {
            _response2 = 'Upload failed: ${jsonResponse['message']}';
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _response2 = 'Error: $e';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _response2 = 'No image selected.';
      });
    }
  }

  Future<void> _verifyFaces() async {
    print("aaa");
    getFaceSimilarity();
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> getFaceSimilarity() async {
    final url = Uri.parse('https://face-similarity.p.rapidapi.com/FaceSimilar');

    // Set up headers
    final headers = {
      // 'x-rapidapi-key': '6cb139b8dfmsh5e511308a133238p19a864jsn9e3890ba2d0e',
      'x-rapidapi-key': Globals.clebritydetection,
      'x-rapidapi-host': 'face-similarity.p.rapidapi.com',
    };

    // Set up the body of the request
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['linkFile'] = _viewUrl2;

    try {
      // Send the request
      final response = await request.send();

      // Get the response data
      final responseData = await response.stream.bytesToString();

      // Parse the response
      final jsonResponse = jsonDecode(responseData);

      // Handle the response
      if (response.statusCode == 200) {
        setState(() {
          imgaebase64 = jsonResponse['data']['imageBase64'];
          nameofcelebrity = jsonResponse['data']['name'];
          group = jsonResponse['data']['group'];
        });
        setState(() {
          _isLoading = false;
        });
        print('Response data: $responseData');
        print('Status Message: ${jsonResponse['statusMessage']}');
        print('Name: ${jsonResponse['data']['name']}');
        print('Group: ${jsonResponse['data']['group']}');
        print('Image Base64: ${jsonResponse['data']['imageBase64']}');
        Get.to(() => CelebrityImage(
              viewUrl2: _viewUrl2!,
              imageurl: jsonResponse['data']['imageBase64'] ?? "aaa",
              name: jsonResponse['data']['name'] ?? "karan",
              group: jsonResponse['data']['group'] ?? "no any group",
            ));
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response data: $responseData');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  String _getVerificationPercentage() {
    try {
      final double percentage = double.parse(_verificationResult);
      return '${(percentage * 100).toStringAsFixed(2)}%';
    } catch (e) {
      return 'Error parsing percentage.';
    }
  }

  Future<void> _saveimage() async {
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
    } catch (e) {}
  }

  Future<void> _captureAndShareScreenshot() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/screenshot.png');
        await file.writeAsBytes(image);

        // Save to gallery
        // await ImageGallerySaver.saveImage(image, quality: 60, name: "screenshot");

        // Share the screenshot
        await Share.shareXFiles([XFile(file.path)],
            text: 'Here is the screenshot!');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: LightThemeColors.white),
        backgroundColor: LightThemeColors.black,
        title: const Text(
          'Celebrity Detection',
          style: TextStyle(color: LightThemeColors.white),
        ),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: RepaintBoundary(
          key: _globalKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_isLoading) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    const Text('Please wait...',
                        style: TextStyle(fontSize: 16.0)),
                  ] else ...[
                    const SizedBox(height: 20),
                    _viewUrl1.isNotEmpty
                        ? const Column(
                            children: [
                              Text('Image 1:',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              // Image.network(_viewUrl1, height: 150, width: 150, fit: BoxFit.cover),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _Showmodel,
                      child: _buildRoundCard(
                        image: _image2,
                        placeholder: 'Pick Image 2',
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _verifyFaces();
                        },
                        child: Text("Check ")),
                    const SizedBox(height: 20),
                    _viewUrl2.isNotEmpty
                        ? const Column(
                            children: [
                              Text('Image 2:',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              // Image.network(_viewUrl2, height: 150, width: 150, fit: BoxFit.cover),
                            ],
                          )
                        : const SizedBox.shrink(),

                    // _viewUrl1.isNotEmpty
                    //     ? Column(
                    //   children: [
                    //     Text('Image 1:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    //     SizedBox(height: 10),
                    //     Image.network(_viewUrl1, height: 150, width: 150, fit: BoxFit.cover),
                    //   ],
                    // )
                    //     : Text(
                    //   _response1.isNotEmpty ? _response1 : 'No image uploaded for Image 1.',
                    //   style: TextStyle(fontSize: 16.0, color: Colors.red),
                    // ),
                    const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: _pickAndUploadImage2,
                    //   style: ElevatedButton.styleFrom(
                    //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    //   ),
                    //   child: Text('Pick and Upload Image 2'),
                    // ),
                    // SizedBox(height: 20),
                    // _viewUrl2.isNotEmpty
                    //     ? Column(
                    //   children: [
                    //     Text('Image 2:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    //     SizedBox(height: 10),
                    //     Image.network(_viewUrl2, height: 150, width: 150, fit: BoxFit.cover),
                    //   ],
                    // )
                    //     : Text(
                    //   _response2.isNotEmpty ? _response2 : 'No image uploaded for Image 2.',
                    //   style: TextStyle(fontSize: 16.0, color: Colors.red),
                    // ),
                    const SizedBox(height: 20),
                    if (!_isLoading) ...[
                      Text(
                        _verificationResult != ''
                            ? _getVerificationPercentage()
                            : 'No verification result.',
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: _captureAndShareScreenshot,
                      //   style: ElevatedButton.styleFrom(
                      //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      //   ),
                      //   child: Text('Capture and Share Screenshot'),
                      // ),
                      _verificationResult != ''
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: _saveimage,
                                  child: const Text('Save To Gallery'),
                                ).marginOnly(right: 20),
                                ElevatedButton(
                                  onPressed: _captureAndShareScreenshot,
                                  child: const Text('Share '),
                                ),
                              ],
                            ).marginOnly(top: 20)
                          : const SizedBox.shrink()
                    ] else ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundCard({XFile? image, required String placeholder}) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(
          color: Colors.white, // Border color
          width: 4.0, // Border width
        ),
      ),
      child: Center(
        child: image == null
            ? Text(
                placeholder,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              )
            : ClipOval(
                child: Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
      ),
    );
  }

  Widget _buildRoundCard1(
      {String? image, required String placeholder, required String name}) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(
          color: Colors.white, // Border color
          width: 4.0, // Border width
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Stack(
          fit: StackFit.expand,
          children: [
            image == null
                ? Center(
                    child: Text(
                      placeholder,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : ClipOval(
                    child: Image.network(
                      image,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CelebrityImage extends StatefulWidget {
  final String imageurl;
  final String name;
  final String group;
  final String viewUrl2;

  CelebrityImage({
    Key? key,
    required this.imageurl,
    required this.name,
    required this.group,
    required this.viewUrl2,
  }) : super(key: key);

  @override
  State<CelebrityImage> createState() => _CelebrityImageState();
}

class _CelebrityImageState extends State<CelebrityImage> {
  double value = 0.5; // Move value here as a class field
  String? imageUrlPath;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _initializeImage();
  }

  Future<void> _initializeImage() async {
    String base64String = _removeDataUrlScheme(widget.imageurl);

    String filename = generateUniqueFilename("png");

    String filePath = await saveBase64Image(base64String, filename);
    setState(() {
      imageUrlPath = filePath;
    });
  }

  String generateUniqueFilename(String extension) {
    final uuid = Uuid();
    return '${uuid.v4()}.$extension'; // Generates a unique filename with the given extension
  }

  Future<String> saveBase64Image(String base64String, String filename) async {
    Uint8List bytes = base64Decode(base64String);

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$filename';

    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  Future<void> _captureScreenshot() async {
    try {
      // Capture screenshot
      final image = await screenshotController.capture();
      if (image != null) {
        // Save the screenshot to a file
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/screenshot.png';
        final file = File(filePath);
        await file.writeAsBytes(image);

        // Save image to gallery
        final result = await ImageGallerySaver.saveFile(filePath);
        if (result != null && result['isSuccess'] == true) {
          // Get.snackbar(
          //   'Success',
          //   'Screenshot saved to gallery and shared successfully!',
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          //   duration: Duration(seconds: 2),
          // );
          // Fluttertoast.showToast(
          //   msg: 'Failed to share image!',
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   backgroundColor: Colors.black,
          //   textColor: Color(0xFF14e7e2),
          //   fontSize: 16.0,
          // );
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to save to gallery.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Color(0xFF14e7e2),
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to save Image.!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Color(0xFF14e7e2),
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'error occurred while save image!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Color(0xFF14e7e2),
        fontSize: 16.0,
      );
      print('Error capturing screenshot: $e');
    }
  }

  Future<Uint8List?> _captureScreenshot2() async {
    try {
      final image = await screenshotController.capture();
      return image;
    } catch (e) {
      return null;
    }
  }

  Future<void> _shareScreenshot(Uint8List image) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/screenshot.png');
      await file.writeAsBytes(image);
      await Share.shareXFiles([XFile(file.path)], text: 'Here is the screenshot!');

    } catch (e) {
      print('Error sharing screenshot: $e');
    }
  }
  Future<void> _captureAndShareScreenshot() async {
    final image = await _captureScreenshot2();
    if (image != null) {
      await _shareScreenshot(image);
    }
  }



  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.imageurl;
    final name = widget.name;
    final group = widget.group;
    final viewUrl2 = widget.viewUrl2;
    if (imageUrlPath == null) {
      print(imageUrlPath);
      return Scaffold(
        backgroundColor: LightThemeColors.black,
        appBar: AppBar(
          backgroundColor: LightThemeColors.black,
          iconTheme: IconThemeData(color: LightThemeColors.white),
          title: Text(
            "Celebrity image",
            style: TextStyle(color: LightThemeColors.white),
          ),
        ),
        body: Center(
            child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    return Scaffold(
      backgroundColor: LightThemeColors.black,
      appBar: AppBar(
        backgroundColor: LightThemeColors.black,
        iconTheme: IconThemeData(color: LightThemeColors.white),
        title: Text(
          "Celebrity image",
          style: TextStyle(color: LightThemeColors.white),
        ),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Image.network(
                  viewUrl2,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              )
            ).marginOnly(bottom: 30),
            imageUrlPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Image.file(
                      File(imageUrlPath!),
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                //before afer effect
                // Center(
                //   child: ClipRRect(
                //     borderRadius: const BorderRadius.all(Radius.circular(30)),
                //     child: BeforeAfter(
                //       thumbColor: LightThemeColors.white,
                //       trackColor: LightThemeColors.white,
                //       value: value,
                //       before: Image.file(
                //         File(imageUrlPath!),
                //         width: 200,
                //         height: 250,
                //         fit: BoxFit.cover,
                //       ),
                //       after: Image.network(
                //         viewUrl2,
                //         height: 250,
                //         width: 200,
                //         fit: BoxFit.cover,
                //       ),
                //       onValueChanged: (newValue) {
                //         setState(() {
                //           value = newValue;
                //         });
                //       },
                //     ),
                //   ),
                // )
                : const Text('No image available'),
            Text(
              'Name: $name',
              style: TextStyle(
                color: LightThemeColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ).marginOnly(top: 20),
            Text(
              'Group: ${group ?? "Not available"}',
              style: TextStyle(
                color: LightThemeColors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(onPressed: (){
              _captureScreenshot();
            }, child: Text("Screen shot")),
            ElevatedButton(onPressed: (){
              _captureAndShareScreenshot();
            }, child: Text("Share"))

          ],
        ),
      ),
    );
  }

  String _removeDataUrlScheme(String dataUrl) {
    final RegExp dataUrlPattern = RegExp(r'^data:image\/[^;]+;base64,');
    return dataUrlPattern.hasMatch(dataUrl)
        ? dataUrl.replaceFirst(dataUrlPattern, '')
        : dataUrl;
  }
}
