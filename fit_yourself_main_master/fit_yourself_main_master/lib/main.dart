import 'package:fit_yourself/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // অবশ্যই এটি ইমপোর্ট করতে হবে
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'app.dart'; // আপনার মূল অ্যাপের ফাইল// আপনার সাইনআপ ফাইল
import 'services/step_counter_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('workoutBox');
  await Hive.openBox('dietBox');
  await Hive.openBox('weightBox');
  await Hive.openBox('settingsBox');

  if (!kIsWeb) {
    try {
      final stepCounter = StepCounterService();
      await stepCounter.initialize();
    } catch (e) {
      debugPrint('Step counter initialization failed: $e');
    }
  }

  // To ensure privacy, we sign out the user every time the app starts
  // This forces the Login/Signup screen to appear on every cold start.
  await FirebaseAuth.instance.signOut();

  runApp(const FitYourselfApp());
}

