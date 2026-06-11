Instructions to use Android-only Firebase configuration

1. Edit `lib/firebase_options.dart` and replace the Android section values with your Android Firebase settings from the Firebase Console (Project Settings > General).

Example values to replace in `static const FirebaseOptions android`:
- `apiKey`: Android web API key (from Firebase)
- `appId`: Android app ID (format: 1:1234567890:android:abcdef123456)
- `messagingSenderId`: Sender ID
- `projectId`: Firebase project ID
- `storageBucket`: project-id.appspot.com

2. We forced `DefaultFirebaseOptions.currentPlatform` to always return the Android options, so only Android keys are required.

3. To run on Android emulator/device:

```bash
flutter pub get
flutter run -d android
```

4. If you want to run on web (Chrome) you must add web API keys in `lib/firebase_options.dart` under `web` as well, or revert `currentPlatform` logic.

5. After replacing values, rebuild:

```bash
flutter clean
flutter pub get
flutter run
```

If you want, paste the Android Firebase config here and I will populate `lib/firebase_options.dart` for you.