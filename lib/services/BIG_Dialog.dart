import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BIG_DialogService {
  // static void backButtonDialog(BuildContext context){
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoAlertDialog(
  //         title: Text('Are you sure you want to exit?',style: TextStyle(color: CupertinoColors.black,fontSize: 45.sp)),
  //         content: const Text("Exiting will stop the current process.\nDo you really want to exit?",textAlign: TextAlign.center,),
  //         actions: [
  //           CupertinoDialogAction(
  //             child: const Text('Exit',style: TextStyle(color: appColor)),
  //             onPressed: () {
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (BuildContext context) {
  //                   return  MyHomePage();
  //                 }),
  //                     (route) => false,
  //               );
  //             },
  //           ),
  //           CupertinoDialogAction(
  //             child: const Text('No',style: TextStyle(color: CupertinoColors.black),),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  // static void backDownloadDialog(BuildContext context){
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoAlertDialog(
  //         title: Text('Are you sure?',style: TextStyle(color: CupertinoColors.black,fontSize: 45.sp)),
  //         content: const Text("Are you sure want to go back without saving this Video",textAlign: TextAlign.center,),
  //         actions: [
  //           CupertinoDialogAction(
  //             child: const Text('No',style: TextStyle(color: appColor)),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           CupertinoDialogAction(
  //             child: const Text('Yes',style: TextStyle(color: CupertinoColors.black),),
  //             onPressed: () {
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (BuildContext context) {
  //                   return   MyHomePage();
  //                 }),
  //                     (route) => false,
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  // static void backDownloadImageDialog(BuildContext context){
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoAlertDialog(
  //         title: Text('Are you sure?',style: TextStyle(color: CupertinoColors.black,fontSize: 45.sp)),
  //         content: const Text("Are you sure want to go back without saving this Image",textAlign: TextAlign.center,),
  //         actions: [
  //           CupertinoDialogAction(
  //             child: const Text('No',style: TextStyle(color: appColor)),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           CupertinoDialogAction(
  //             child: const Text('Yes',style: TextStyle(color: CupertinoColors.black),),
  //             onPressed: () {
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (BuildContext context) {
  //                   return   MyHomePage();
  //                 }),
  //                     (route) => false,
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  static void showLoading(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        useRootNavigator: false,
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(
              dialogBackgroundColor: Colors.transparent,
              dialogTheme:
              const DialogTheme(backgroundColor: Colors.transparent),
            ),
            child: const CupertinoAlertDialog(
              title: Center(child: CupertinoActivityIndicator()),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }
  }

  static void restorePurchasesDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('No Purchases Found'),
            content: const Text(
                "You've no active subscriptions. Kindly purchase any of the given subscriptions."),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }
  }

  static void showCheckConnectivity(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Connection'),
            content: const Text('Check your internet connection.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            title: const Text('Connection'),
            content: const Text('Check your internet connection.'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // static void showBackButton(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return  AlertDialog(
  //         title:   Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Image.asset('assets/remove_object/text.png',height: 194.h,width: 578.w,),
  //             SizedBox(
  //               height: 20.h,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 SizedBox(
  //                   height: 120.h,
  //                   width: 300.w,
  //                   child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                           backgroundColor: appbackgroundColor
  //                       ),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       }, child: const Text('Cancel',style: TextStyle(color: CupertinoColors.white),)
  //                   ),
  //                 ),
  //                 SizedBox(width: 20.w,),
  //                 SizedBox(
  //                   height: 120.h,
  //                   width: 300.w,
  //                   child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                           backgroundColor: appColor
  //                       ),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         Navigator.pushAndRemoveUntil(
  //                           context,
  //                           MaterialPageRoute(builder: (BuildContext context) {
  //                             return   MyHomePage();
  //                           }),
  //                               (route) => false,
  //                         );
  //                       }, child: const Text('Exit',style: TextStyle(color: CupertinoColors.white),)
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  static void showpermissiondialog(BuildContext context, String item) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text('Allow access to $item in the Setting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Setting'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            content: Text('Allow access to $item in the Setting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Setting'),
              ),
            ],
          );
        },
      );
    }
  }

//   static void uploadingDialog(context,String item) {
//     Platform.isAndroid
//         ? showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return  AlertDialog(
//           title:  Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const CircularProgressIndicator(color: cupertinoActivityIndicatorColor),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Uploading $item'),
//                   const Text('Please wait...'),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     ) : showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               iosIndicator,
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Uploading $item'),
//                   const Text('Please wait...'),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
}
