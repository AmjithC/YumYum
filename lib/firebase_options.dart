// Replace this file by running:  flutterfire configure --project=yumquick-c31f3
// App IDs/project below come from your firebase.json; the API keys are NOT in
// that file, so copy them from Firebase Console > Project settings, or just
// run `flutterfire configure` which generates this file for you.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const String _projectId = 'yumquick-c31f3';
  static const String _messagingSenderId = '1048016537037';

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:1048016537037:android:ff2680eafc42a772fc7084',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: 'yumquick-c31f3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:1048016537037:ios:ae8b0f72db331dc2fc7084',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: 'yumquick-c31f3.firebasestorage.app',
    iosBundleId: 'com.example.yumquick',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:1048016537037:ios:ae8b0f72db331dc2fc7084',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: 'yumquick-c31f3.firebasestorage.app',
    iosBundleId: 'com.example.yumquick',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:1048016537037:web:a18f7f17256d27affc7084',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    authDomain: 'yumquick-c31f3.firebaseapp.com',
    storageBucket: 'yumquick-c31f3.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:1048016537037:web:cac2720dbb4fad74fc7084',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    authDomain: 'yumquick-c31f3.firebaseapp.com',
    storageBucket: 'yumquick-c31f3.firebasestorage.app',
  );
}
