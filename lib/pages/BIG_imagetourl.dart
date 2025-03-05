import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/pages/Babygenerator/BIG_Babyimagegeneratorapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class BIG_Celebritydetection extends StatefulWidget {
  @override
  _ImagetourlState createState() => _ImagetourlState();
}

class _ImagetourlState extends State<BIG_Celebritydetection> {
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
  bool calculationloafing = false;
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

  Future<void> _pickAndUploadImage2() async {
    setState(() {
      _viewUrl2 ='';
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image!.path,
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
          _image1 = XFile(croppedFile.path);
          Imagetourl(_image1!);
          _verifyFaces();
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
    print(image1url);
    print(_viewUrl2);
    if (image1url != null && _viewUrl2.isNotEmpty) {
      print("karan");
      // setState(() {
      //   _isLoading = true;
      //   _loading = true;
      // });

      final url = Uri.parse(
          'https://face-verification2.p.rapidapi.com/faceverification');
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'x-rapidapi-key':
              '2eb8182597mshf9aa2f9f180b601p1d5d72jsn355eaa91fc9c',
          'x-rapidapi-host': 'face-verification2.p.rapidapi.com',
        })
        ..fields['linkFile1'] = image1url!
        ..fields['linkFile2'] = _viewUrl2;

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        if (jsonResponse['statusCode'] == 200) {
          setState(() {
            _verificationResult = '${jsonResponse['data']['similarPercent']}';
            print(_verificationResult);
            print("sonikaran");
            _isLoading = false;
          });
        } else {
          setState(() {
            _verificationResult =
                'Verification failed: ${jsonResponse['message']}';
            _verificationResult = '0';
          });
        }

        _loading = false;
        _result = true;
      } catch (e) {
        setState(() {
          // _verificationResult = '0';
          // _isLoading = false;
          _loading = false;
        });
      }
    } else {
      setState(() {
        // _verificationResult = 'Please upload both images first.';
      });
    }
  }

  String _getVerificationPercentage() {
    try {
      setState(() {
        calculationloafing = true;
      });
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
        Get.snackbar(
          'Success',
          'Image save successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
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
          'Celebrity Detection2',
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
                    const CircularProgressIndicator(
                      color: LightThemeColors.white,
                    ),
                    const SizedBox(height: 20),
                    const Text('Please wait...',
                        style: TextStyle(
                            fontSize: 16.0, color: LightThemeColors.white)),
                  ] else ...[
                    GestureDetector(
                      // onTap: () async {
                      //   var result = await Get.to(Celebrityimage());
                      //   if (result != null) {
                      //     print('Result from Second Screen: ${result}');
                      //     print(result['image']);
                      //     setState(() {
                      //       // image1url = result.image;
                      //       // Name = result.name;
                      //     });
                      //   }
                      // },
                      onTap: () async {
                        var result = await Get.to(const Celebrityimage());

                        if (result != null) {
                          String? imageUrl = result['url'];
                          String? name = result['name'];

                          setState(() {
                            image1url = imageUrl;
                            Name = name;
                            // Update other state variables as needed
                            _verifyFaces();
                          });
                        }
                      },
                      child: _buildRoundCard1(
                          image: image1url,
                          placeholder: 'Pick Image 1',
                          name: "$Name"),
                    ),
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
                      onTap: _pickAndUploadImage2,
                      child: _buildRoundCard(
                        image: _image2,
                        placeholder: 'Pick Image 2',
                      ),
                    ),
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
                    image1url != "" && _viewUrl2 != "" ?
                    _verificationResult != '' ? SizedBox.shrink():
                        CircularProgressIndicator()
                    :SizedBox.shrink()
                    ,

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
                      // calculationloafing == true ?
                      // CircularProgressIndicator(color: LightThemeColors.white,).marginOnly(top: 15) :SizedBox.shrink(),
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
                      const CircularProgressIndicator(
                        color: LightThemeColors.white,
                      ),
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

class Celebrityimage extends StatefulWidget {
  const Celebrityimage({super.key});

  @override
  State<Celebrityimage> createState() => _CelebrityimageState();
}

class _CelebrityimageState extends State<Celebrityimage> {
  final List<Map<String, String>> imageData = [
    {
      'name': 'Virat Kohli',
      'url':
          'https://img1.hscicdn.com/image/upload/f_auto,t_ds_square_w_320,q_50/lsci/db/PICTURES/CMS/316600/316605.png'
    },
    {
      'name': 'Modi',
      'url': 'https://spmrf.org/wp-content/uploads/2020/09/ModiJiji.jpg'
    },
    {
      'name': 'Ronaldo',
      'url':
          'https://cdn.britannica.com/73/234573-050-8EE03E16/Cristiano-Ronaldo-ceremony-rename-airport-Santa-Cruz-Madeira-Portugal-March-29-2017.jpg'
    },
    {
      'name': 'Virat Kohli',
      'url': 'https://documents.iplt20.com/ipl/IPLHeadshot2024/57.png'
    },
    {
      'name': 'Messi',
      'url':
          'https://assets.architecturaldigest.in/photos/63806da6d2c4a1a597b273fd/1:1/w_2896,h_2896,c_limit/1442809583'
    },
    {
      'name': 'Shubhaman Gil',
      'url': 'https://documents.iplt20.com/ipl/IPLHeadshot2024/62.png'
    },
    {
      'name': 'Carry Minati',
      'url':
          'https://indianewengland.com/wp-content/uploads/2023/08/CarryMinati-1.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text("Celebrity Images",
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: imageData.length,
          itemBuilder: (context, index) {
            final data = imageData[index];
            return GestureDetector(
              onTap: () {
                Get.back(result: {
                  'url': '${data['url']}',
                  'name': '${data['name']}'
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        data['url']!,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            data['name']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
