import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBW3U8Iryeayr5I9mwUwLY7yyR89pkeXYs',
    appId: '1:934799091589:web:755e4796a80e2f062546ec',
    messagingSenderId: '934799091589',
    projectId: 'bookswap-af99d',
    authDomain: 'bookswap-af99d.firebaseapp.com',
    storageBucket: 'bookswap-af99d.firebasestorage.app',
    measurementId: 'G-V9WKWW9T3H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlGl17sXT45E3KQ19mEJ1XqOLU8YgkoGw',
    appId: '1:934799091589:android:bd591b62749a82602546ec',
    messagingSenderId: '934799091589',
    projectId: 'bookswap-af99d',
    storageBucket: 'bookswap-af99d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSg6ge97v8_dswRko6M3s_feUFr66JKl4',
    appId: '1:934799091589:ios:7af84c472fb8fff92546ec',
    messagingSenderId: '934799091589',
    projectId: 'bookswap-af99d',
    storageBucket: 'bookswap-af99d.firebasestorage.app',
    iosBundleId: 'com.example.bookswap',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBSg6ge97v8_dswRko6M3s_feUFr66JKl4',
    appId: '1:934799091589:ios:7af84c472fb8fff92546ec',
    messagingSenderId: '934799091589',
    projectId: 'bookswap-af99d',
    storageBucket: 'bookswap-af99d.firebasestorage.app',
    iosBundleId: 'com.example.bookswap',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBW3U8Iryeayr5I9mwUwLY7yyR89pkeXYs',
    appId: '1:934799091589:web:fce9de2afdcbc29f2546ec',
    messagingSenderId: '934799091589',
    projectId: 'bookswap-af99d',
    authDomain: 'bookswap-af99d.firebaseapp.com',
    storageBucket: 'bookswap-af99d.firebasestorage.app',
    measurementId: 'G-KV2ZQFQKD9',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR-LINUX-API-KEY',
    appId: 'YOUR-LINUX-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'bookswap-app',
    storageBucket: 'bookswap-app.appspot.com',
  );
}