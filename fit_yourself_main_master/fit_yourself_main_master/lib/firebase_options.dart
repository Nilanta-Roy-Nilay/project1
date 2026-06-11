// Replace these placeholder values with your actual Firebase project settings.
// You can get them from the Firebase Console under Project settings > General.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

// Android-only Firebase options. Replace the placeholders below with your
// Android Firebase configuration from the Firebase Console (Project settings).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // You should add your Web API key here if you want to support Web.
      // For now, returning android options on web might cause the Platform error.
      // Ideally, you should run `flutterfire configure` to generate this file.
      return android; 
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9mqQdSyaHfUldaMiCt4mKwBFiIe239jY',
    appId: '1:859467709859:android:37253677b01ba3c165ee16',
    messagingSenderId: '859467709859',
    projectId: 'fit-yourself-main-master',
    storageBucket: 'fit-yourself-main-master.firebasestorage.app',
  );
}
