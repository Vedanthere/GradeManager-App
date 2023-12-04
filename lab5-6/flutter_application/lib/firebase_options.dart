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
    apiKey: 'AIzaSyCc9igmPwN9dvMrnv_N4bUdez1XQ2uqans',
    appId: '1:768173370272:web:4ea9081c0b9dcea2c512c5',
    messagingSenderId: '768173370272',
    projectId: 'fir-example-dcffa',
    authDomain: 'fir-example-dcffa.firebaseapp.com',
    storageBucket: 'fir-example-dcffa.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdPbWq5onYoMqvUD102emnYDEltSXRwKQ',
    appId: '1:768173370272:android:f84ca42f1b17b168c512c5',
    messagingSenderId: '768173370272',
    projectId: 'fir-example-dcffa',
    storageBucket: 'fir-example-dcffa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAo8S9sdjW4Wx0v1KE0eVIzcYBhryE_Qs',
    appId: '1:768173370272:ios:73eadad21cc978fac512c5',
    messagingSenderId: '768173370272',
    projectId: 'fir-example-dcffa',
    storageBucket: 'fir-example-dcffa.appspot.com',
    iosBundleId: 'com.example.flutterApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAo8S9sdjW4Wx0v1KE0eVIzcYBhryE_Qs',
    appId: '1:768173370272:ios:b0d6f40cbf2b12ccc512c5',
    messagingSenderId: '768173370272',
    projectId: 'fir-example-dcffa',
    storageBucket: 'fir-example-dcffa.appspot.com',
    iosBundleId: 'com.example.flutterApplication.RunnerTests',
  );
}
