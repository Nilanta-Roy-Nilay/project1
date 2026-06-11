import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Generated Firebase configuration used by `Firebase.initializeApp()`.
///
/// Replace the placeholder values with the values from your Firebase project
/// (use `flutterfire configure` or the Firebase console -> Project settings).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBAwFqvTLPARKCj0ma7Ub4sYGcfvo2f9ps',
    authDomain: 'fitaxis-3.firebaseapp.com',
    databaseURL: "https://fitaxis-3-default-rtdb.firebaseio.com",
    projectId: 'fitaxis-3',
    storageBucket: 'fitaxis-3.firebasestorage.app',
    messagingSenderId: '189629092238',
    appId: '1:189629092238:web:2e08e1385285a3204994df',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtPBFJ79i9Za86sFALCCK2J19H2EZpH7Y',
    appId: '1:189629092238:android:cf71552a58a8f1da4994df',
    messagingSenderId: '189629092238',
    projectId: 'fitaxis-3',
    storageBucket: 'fitaxis-3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTAs70E5r1y_zZxJiyADJZVkYAFVSy_g8',
    appId: '1:189629092238:ios:1dad6a9423342b934994df',
    messagingSenderId: '189629092238',
    projectId: 'fitaxis-3',
    androidClientId:
        '189629092238-si6lgqph8lrtbo20jjh3jou3omh8q40p.apps.googleusercontent.com',
    iosClientId:
        '189629092238-5q8v5q8v5q8v5q8v5q8v5q8v5q8v5q8v.apps.googleusercontent.com',
    storageBucket: 'fitaxis-3.firebasestorage.app',
  );
}
