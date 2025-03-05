import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class BIG_MyPermissionHandler {
  static Future<bool> checkPermission(String permissionName) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt < 33 && permissionName == 'gallery') {
        final statues = await [Permission.storage].request();
        PermissionStatus? statusPhotos = statues[Permission.storage];
        if (statusPhotos == PermissionStatus.granted) {
          return true;
        } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
          Fluttertoast.showToast(
              msg: 'permanentlyDenied',
              backgroundColor: const Color(0xff00cbe7),
              textColor: const Color(0xffffffff));
          //showPermissionDialog(context, permissionName);
          return false;
        } else if (statusPhotos == PermissionStatus.limited) {
          Fluttertoast.showToast(
              msg: 'limited',
              backgroundColor: const Color(0xff00cbe7),
              textColor: const Color(0xffffffff));
          //showLimitedPermissionDialog(context, permissionName);
          return false;
        } else {
          return false;
        }
      }
      if (sdkInt < 33 && permissionName == 'camera') {
        final statues = await [Permission.storage].request();
        PermissionStatus? statusPhotos = statues[Permission.storage];
        if (statusPhotos == PermissionStatus.granted) {
          return true;
        } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
          Fluttertoast.showToast(
              msg: 'permanentlyDenied',
              backgroundColor: const Color(0xff00cbe7),
              textColor: const Color(0xffffffff));
          //showPermissionDialog(context, permissionName);
          return false;
        } else if (statusPhotos == PermissionStatus.limited) {
          Fluttertoast.showToast(
              msg: 'limited',
              backgroundColor: const Color(0xff00cbe7),
              textColor: const Color(0xffffffff));
          //showLimitedPermissionDialog(context, permissionName);
          return false;
        } else {
          return false;
        }
      }
    }
    // FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statues;
    switch (permissionName) {
      case 'camera':
        {
          statues = await [Permission.camera].request();
          PermissionStatus? statusCamera = statues[Permission.camera];
          if (statusCamera == PermissionStatus.granted) {
            return true;
          } else if (statusCamera == PermissionStatus.permanentlyDenied) {
            Fluttertoast.showToast(
                msg: 'permanentlyDenied',
                backgroundColor: const Color(0xff00cbe7),
                textColor: const Color(0xffffffff));
            //showPermissionDialog(context, permissionName);
            return false;
          } else {
            return false;
          }
        }
      case 'gallery':
        {
          statues = await [Permission.photos].request();
          PermissionStatus? statusPhotos = statues[Permission.photos];
          if (statusPhotos == PermissionStatus.granted) {
            return true;
          } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
            Fluttertoast.showToast(
                msg: 'permanentlyDenied',
                backgroundColor: CupertinoColors.black,
                textColor: CupertinoColors.white);
            //showPermissionDialog(context, permissionName);
            return false;
          } else if (statusPhotos == PermissionStatus.limited) {
            // Fluttertoast.showToast(msg: 'limited',backgroundColor: const Color(0xff00cbe7),textColor: const Color(0xffffffff));
            //showLimitedPermissionDialog(context, permissionName);
            return true;
          } else {
            return false;
          }
        }
      case 'location':
        {
          statues = await [Permission.location].request();
          PermissionStatus? statusPhotos = statues[Permission.location];
          if (statusPhotos == PermissionStatus.granted) {
            return true;
          } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
            Fluttertoast.showToast(
                msg: 'permanentlyDenied',
                backgroundColor: const Color(0xff00cbe7),
                textColor: const Color(0xffffffff));
            //showPermissionDialog(context, permissionName);
            return false;
          } else if (statusPhotos == PermissionStatus.limited) {
            Fluttertoast.showToast(
                msg: 'limited',
                backgroundColor: const Color(0xff00cbe7),
                textColor: const Color(0xffffffff));
            //showLimitedPermissionDialog(context, permissionName);
            return false;
          } else {
            return false;
          }
        }
      case 'microphone':
        {
          statues = await [Permission.microphone].request();
          PermissionStatus? statusPhotos = statues[Permission.microphone];
          if (statusPhotos == PermissionStatus.granted) {
            return true;
          } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
            Fluttertoast.showToast(
                msg: 'permanentlyDenied',
                backgroundColor: const Color(0xff00cbe7),
                textColor: const Color(0xffffffff));
            //showPermissionDialog(context, permissionName);
            return false;
          } else if (statusPhotos == PermissionStatus.limited) {
            Fluttertoast.showToast(
                msg: 'limited',
                backgroundColor: const Color(0xff00cbe7),
                textColor: const Color(0xffffffff));
            //showLimitedPermissionDialog(context, permissionName);
            return false;
          } else {
            return false;
          }
        }
      case 'video':
        {
          statues = await [Permission.videos].request();
          PermissionStatus? statusPhotos = statues[Permission.videos];
          if (statusPhotos == PermissionStatus.granted) {
            return true;
          } else if (statusPhotos == PermissionStatus.permanentlyDenied) {
            Fluttertoast.showToast(
                msg: 'permanentlyDenied',
                backgroundColor: const Color(0xff00cbe7),
                textColor: const Color(0xffffffff));
            //showPermissionDialog(context, permissionName);
            return false;
          } else if (statusPhotos == PermissionStatus.limited) {
            Fluttertoast.showToast(
                msg: 'limited',
                backgroundColor: const Color(0xff00cbe7),
                textColor: const Color(0xffffffff));
            //showLimitedPermissionDialog(context, permissionName);
            return false;
          } else {
            return false;
          }
        }
    }
    return false;
  }
}
