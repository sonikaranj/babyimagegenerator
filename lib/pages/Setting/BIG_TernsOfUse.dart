import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';


// android:usesCleartextTraffic="true"

class BIG_TermsOfUse extends StatefulWidget {
  const BIG_TermsOfUse({Key? key}) : super(key: key);

  @override
  State<BIG_TermsOfUse> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<BIG_TermsOfUse> {
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
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: PressUnpress(
        //     imageAssetUnPress: 'lib/Images/Commonimg/back_unpress.png',
        //     imageAssetPress: 'lib/Images/Commonimg/back_press.png',
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     height: 80.h,
        //     width: 80.w,
        //     child: null,
        //   ),
        // ),
        title: Text('Terms Of Use',style: TextStyle(color: Colors.white, fontSize: 65.sp),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
