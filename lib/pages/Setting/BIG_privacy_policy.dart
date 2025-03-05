import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';



class BIG_PrivacyPolicy extends StatefulWidget {
  const BIG_PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<BIG_PrivacyPolicy> createState() => _BIG_PrivacyPolicyState();
}

class _BIG_PrivacyPolicyState extends State<BIG_PrivacyPolicy> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadRequest(
        Uri.parse('https://privacy.net/analyzer/'),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F8FF),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F8FF),
        // leading: Padding(
        //   padding: const EdgeInsets.all(12),
        //   child: PressUnpress(
        //     imageAssetUnPress: 'assets/Images/common_img/back_unpress.png',
        //     imageAssetPress: 'assets/Images/common_img/back_press.png',
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     height: 80.h,
        //     width: 80.w,
        //     child: null,
        //   ),
        // ),
        title: Text('Privacy Policy',style: TextStyle(color: Colors.black, fontSize: 45.sp,fontFamily: "medium"),),
      ),
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
