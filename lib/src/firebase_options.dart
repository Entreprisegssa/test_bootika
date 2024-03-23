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
    apiKey: 'AIzaSyCdrJ1ako9M6qkELkxwGw-jIt1lM7SxgeI',
    appId: '1:667656625654:web:0467f1df5a02d966dc7bd7',
    messagingSenderId: '667656625654',
    projectId: 'bootika-eb4fe',
    authDomain: 'bootika-eb4fe.firebaseapp.com',
    databaseURL: 'https://bootika-eb4fe-default-rtdb.firebaseio.com',
    storageBucket: 'bootika-eb4fe.appspot.com',
    measurementId: 'G-J4ETPH6BQ2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwOgVLDTth071sXGRvRzUeeP01TmPZsoA',
    appId: '1:667656625654:android:86421135651af425dc7bd7',
    messagingSenderId: '667656625654',
    projectId: 'bootika-eb4fe',
    databaseURL: 'https://bootika-eb4fe-default-rtdb.firebaseio.com',
    storageBucket: 'bootika-eb4fe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjB3QvFquvjzEwF3f3mVUripsvfWU6LL0',
    appId: '1:667656625654:ios:377f01c3665a9b9cdc7bd7',
    messagingSenderId: '667656625654',
    projectId: 'bootika-eb4fe',
    databaseURL: 'https://bootika-eb4fe-default-rtdb.firebaseio.com',
    storageBucket: 'bootika-eb4fe.appspot.com',
    iosBundleId: 'com.example.bootika',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjB3QvFquvjzEwF3f3mVUripsvfWU6LL0',
    appId: '1:667656625654:ios:044fc186b84f9c97dc7bd7',
    messagingSenderId: '667656625654',
    projectId: 'bootika-eb4fe',
    databaseURL: 'https://bootika-eb4fe-default-rtdb.firebaseio.com',
    storageBucket: 'bootika-eb4fe.appspot.com',
    iosBundleId: 'com.example.bootika.RunnerTests',
  );
}