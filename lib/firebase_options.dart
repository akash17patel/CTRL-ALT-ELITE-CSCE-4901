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
    apiKey: 'AIzaSyCAOvbN1v-kZLKsnNA0ERzb27dB3URuXNM',
    appId: '1:962638120483:web:42746c3fc48c2da5b4d396',
    messagingSenderId: '962638120483',
    projectId: 'mindlift-babe1',
    authDomain: 'mindlift-babe1.firebaseapp.com',
    databaseURL: 'https://mindlift-babe1-default-rtdb.firebaseio.com',
    storageBucket: 'mindlift-babe1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6HpsXKRof91Lxs7guCv4vIHZjWoukvr8',
    appId: '1:962638120483:android:33b48de78880bbe5b4d396',
    messagingSenderId: '962638120483',
    projectId: 'mindlift-babe1',
    databaseURL: 'https://mindlift-babe1-default-rtdb.firebaseio.com',
    storageBucket: 'mindlift-babe1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAE7S7avfYPBT9Kj-4Le24eggHObMviQug',
    appId: '1:962638120483:ios:a282e68c3744c526b4d396',
    messagingSenderId: '962638120483',
    projectId: 'mindlift-babe1',
    databaseURL: 'https://mindlift-babe1-default-rtdb.firebaseio.com',
    storageBucket: 'mindlift-babe1.appspot.com',
    androidClientId: '962638120483-aep47p4gibsnho7s0e6di2g6me7sdr2q.apps.googleusercontent.com',
    iosClientId: '962638120483-65o2f4s300hg44d0fp96t4tga26viuvn.apps.googleusercontent.com',
    iosBundleId: 'com.example.mindliftFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAE7S7avfYPBT9Kj-4Le24eggHObMviQug',
    appId: '1:962638120483:ios:ba5d5c717bfd4c26b4d396',
    messagingSenderId: '962638120483',
    projectId: 'mindlift-babe1',
    databaseURL: 'https://mindlift-babe1-default-rtdb.firebaseio.com',
    storageBucket: 'mindlift-babe1.appspot.com',
    androidClientId: '962638120483-aep47p4gibsnho7s0e6di2g6me7sdr2q.apps.googleusercontent.com',
    iosClientId: '962638120483-nbtjtle69g7fugmtanalcaiiug45ght2.apps.googleusercontent.com',
    iosBundleId: 'com.example.mindliftFlutter.RunnerTests',
  );
}
