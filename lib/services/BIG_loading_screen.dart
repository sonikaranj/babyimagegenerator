
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';


@protected
final scaffoldGlobalKey = GlobalKey<ScaffoldState>();

class BIG_LoadingScreen {
  final GlobalKey globalKey;

  BIG_LoadingScreen(this.globalKey);

  show([String? text]) {
    print("hello");
    showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) => Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.3),
        body: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(15.w),
            color: Colors.black,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Lottie.asset(Assets.imagesPleaseWait, height: 100.w),
                // CircularProgressIndicator(color: CupertinoColors.activeBlue,),
                CupertinoActivityIndicator(color: Colors.white,radius: 20,),
                // Image.asset(
                //   Assets.imagesPleaseWait,
                //   width: 70.w,
                //   height: 70.w,
                // ),
                Text(
                  "please Wait",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                ).marginSymmetric(horizontal: 50.w, vertical: 5.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  hide() {
    if (Get.context == null) return;

    Navigator.pop(Get.context!);
  }
}

@protected
var loadingScreen = BIG_LoadingScreen(scaffoldGlobalKey);
