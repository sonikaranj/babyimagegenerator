// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;
//
// /// Default [FirebaseOptions] for use with your Firebase apps.
// ///
// /// Example:
// /// ```dart
// /// import 'firebase_options.dart';
// /// // ...
// /// await Firebase.initializeApp(
// ///   options: DefaultFirebaseOptions.currentPlatform,
// /// );
// /// ```
// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       throw UnsupportedError(
//         'DefaultFirebaseOptions have not been configured for web - '
//         'you can reconfigure this by running the FlutterFire CLI again.',
//       );
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for macos - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.windows:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for windows - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }
//
//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyCIGssTVgebxpG8rJVZBK7zIxIcpiwrPCg',
//     appId: '1:682649095886:ios:ebefe52af3708f765cca9f',
//     messagingSenderId: '682649095886',
//     projectId: 'nbalivescore-5e438',
//     storageBucket: 'nbalivescore-5e438.appspot.com',
//     iosBundleId: 'advance.nbascorefootballscore.com',
//   );
//
//   static const FirebaseOptions android =  FirebaseOptions(
//   apiKey: 'AIzaSyBky4cCNW-4qeGkCXysd6HAqWyn0NHto6c',
//   appId: '1:956400082004:android:77130d81b7cf0d0ac221c1',
//   messagingSenderId: '956400082004',
//   projectId: 'babyimagegenerate',
//   storageBucket: 'babyimagegenerate.appspot.com',
//   );
//
// }
