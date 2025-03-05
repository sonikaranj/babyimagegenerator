import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';  // Updated to share_plus


class BIG_SubmitRating {
  Future<void> submitRating(BuildContext context) async {
    LaunchReview.launch(writeReview: true, iOSAppId: "");
  }

 Future<void> shareContent(BuildContext context) async {
    const String text = 'Check out this awesome app!';
    const String subject = 'Awesome App';
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String packageName = packageInfo.packageName;
    final String appStoreUrl = 'https://apps.apple.com/app/$packageName';
    final String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';

    // Use share_plus for sharing content
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await Share.share('$text\n\n$appStoreUrl', subject: subject);
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      await Share.share('$text\n\n$playStoreUrl', subject: subject);
    } else {
      throw PlatformException(code: 'PLATFORM_NOT_SUPPORTED', message: 'Sharing is not supported on this platform.');
    }
  }
}
