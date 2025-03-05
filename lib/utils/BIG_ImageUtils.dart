import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
class BIG_ImageUtils {

  // close utils
  static Future<void> showCloseConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Confirm Close',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to close this process? This action cannot be undone.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Execute the confirmation callback
              },
            ),
          ],
        );
      },
    );
  }

  final picker = ImagePicker();

  static BuildContext? get context => null;

  static  Future<void> requestPermissions() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with storage-related operations
    } else if (status.isDenied) {
      // Handle the case where permission is denied
    } else if (status.isPermanentlyDenied) {
      // Handle the case where permission is permanently denied
      openAppSettings();  // Optional: open app settings for manual permission granting
    }
  }

  // Function to pick image from either camera or gallery
  Future<File?> pickImage({bool fromCamera = false}) async {
   await requestPermissions();
    final pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }


  Future<File?> cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 50,
      aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 4),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio4x3, // Set to 4:3 ratio
          lockAspectRatio: false, // Lock aspect ratio to maintain 4:3

        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: Get.context!,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(width: 520, height: 520),
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

 static Future<File?> saveImageToTempDirectory(File imageFile) async {
    try {
      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();

      // Create a new file in the temporary directory
      final String filePath = '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File newImageFile = await imageFile.copy(filePath);

      // Return the new file
      return newImageFile;
    } catch (e) {
      debugPrint("Error saving image to temp directory: $e");
      return null;
    }
  }

  static Future<bool> saveImageToGallery(String imageUrl) async {
    try {
      // Fetch the image from the network.
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Convert the image data to bytes.
        Uint8List imageBytes = response.bodyBytes;

        // Save the image to the gallery using `image_gallery_saver`.
        final result = await ImageGallerySaver.saveImage(imageBytes);

        if (result['isSuccess'] == true) {
          Fluttertoast.showToast(
              msg: "Image saved successfully.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor:  Color(0xFF14e7e2),
              fontSize: 16.0
          );
          return true; // Image saved successfully.
        } else {
          throw Exception('Failed to save image to gallery');
        }
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      print('Error saving image: $e');
      return false;
    }
  }

  static void showLoadingDialog(BuildContext context, {String? message="Loading"}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,), // The loading spinner,
              )
          ),
        );
      },
    );
  }


  static Future<void> shareImageFromUrl(String imageUrl) async {
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      print("response");
     print(response.body);
      if (response.statusCode == 200) {
        // Get the temporary directory
        final tempDir = await getTemporaryDirectory();
        print(tempDir);
        // Extract the file name without query parameters
        final uri = Uri.parse(imageUrl);
        final fileName = path.basename(uri.path); // This will exclude query params

        // Create the full file path
        final filePath = path.join(tempDir.path, fileName);
        print(filePath);
        // Save the image to a temporary file

        // Share the image using the file path
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

// Share the image using the file path
//         await Share.shareXFiles([XFile(filePath)]);
        await Share.shareXFiles([XFile(filePath)],
            subject: "subject",
            text: "text",
            );
      } else {
        throw Exception('Failed to download image.');
      }
     // await Share.share('check out my website https://example.com');
    } catch (e) {
      print('Error sharing image: $e');
    }
  }


  // Function to hide the loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Future<void> saveImageToGalleryBytes(Uint8List imageBytes) async {
    try {
      final result = await ImageGallerySaver.saveImage(imageBytes,
          quality: 60,
          name: "processed_image_${DateTime.now().millisecondsSinceEpoch}");

      if (result['isSuccess']) {
        Fluttertoast.showToast(
          msg: "Image saved to gallery!",
          toastLength: Toast.LENGTH_SHORT, // LENGTH_SHORT or LENGTH_LONG
          gravity: ToastGravity.BOTTOM,    // Can be TOP, CENTER, or BOTTOM
          timeInSecForIosWeb: 1,           // Toast duration for iOS and Web
          backgroundColor: Colors.black,
          textColor:  Color(0xFF14e7e2),
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to save image!",
          toastLength: Toast.LENGTH_SHORT, // LENGTH_SHORT or LENGTH_LONG
          gravity: ToastGravity.BOTTOM,    // Can be TOP, CENTER, or BOTTOM
          timeInSecForIosWeb: 1,           // Toast duration for iOS and Web
          backgroundColor: Colors.black,
          textColor:  Color(0xFF14e7e2),
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save image!",
        toastLength: Toast.LENGTH_SHORT, // LENGTH_SHORT or LENGTH_LONG
        gravity: ToastGravity.BOTTOM,    // Can be TOP, CENTER, or BOTTOM
        timeInSecForIosWeb: 1,           // Toast duration for iOS and Web
        backgroundColor: Colors.black,
        textColor:  Color(0xFF14e7e2),
        fontSize: 16.0,
      );
    }
  }

  /// Share the image bytes using `share_plus`
  static Future<void> shareImageBytes(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_image.png');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(file.path)],
          text: 'Here is the processed image!');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share image!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
