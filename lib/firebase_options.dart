// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwHnoBQIo9WAGsF53mIFqOn_Yzzi2Y_R4',
    appId: '1:386096247510:web:a9584cc2f06589e5354f77',
    messagingSenderId: '386096247510',
    projectId: 'chatapp-bb8fa',
    authDomain: 'chatapp-bb8fa.firebaseapp.com',
    storageBucket: 'chatapp-bb8fa.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvRjKjrmipRPu_MXSUBCQ0ae7-GqyNA3g',
    appId: '1:386096247510:android:219841e20a303db1354f77',
    messagingSenderId: '386096247510',
    projectId: 'chatapp-bb8fa',
    storageBucket: 'chatapp-bb8fa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7-QTn_EqAOHheb8LJOcK-ri4AYxSVc7k',
    appId: '1:386096247510:ios:37c4bbfa29b74656354f77',
    messagingSenderId: '386096247510',
    projectId: 'chatapp-bb8fa',
    storageBucket: 'chatapp-bb8fa.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7-QTn_EqAOHheb8LJOcK-ri4AYxSVc7k',
    appId: '1:386096247510:ios:d1dd31b0a880e79b354f77',
    messagingSenderId: '386096247510',
    projectId: 'chatapp-bb8fa',
    storageBucket: 'chatapp-bb8fa.appspot.com',
    iosBundleId: 'com.example.chatapp.RunnerTests',
  );
}