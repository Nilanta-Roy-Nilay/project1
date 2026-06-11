import 'package:flutter/material.dart';
import 'package:fit_yourself/screens/splash_screen.dart';
import 'package:fit_yourself/screens/auth/auth_gate.dart';
import 'package:fit_yourself/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FitYourselfApp extends StatefulWidget {
  const FitYourselfApp({super.key});

  @override
  State<FitYourselfApp> createState() => _FitYourselfAppState();
}

class _FitYourselfAppState extends State<FitYourselfApp> with WidgetsBindingObserver {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateStatus('online');
    // Only show splash once per app session
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  void dispose() {
    _updateStatus('offline');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateStatus('online');
    } else {
      _updateStatus('offline');
    }
  }

  void _updateStatus(String status) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'status': status,
        'lastSeen': FieldValue.serverTimestamp(),
      }).catchError((e) => debugPrint('Status update error: $e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settingsBox').listenable(),
      builder: (context, box, child) {
        final isDarkMode = box.get('darkMode', defaultValue: false);
        return MaterialApp(
          title: 'Fit Yourself',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          // Use AuthGate directly if splash is done to prevent reset on theme change
          home: _showSplash ? const SplashScreen() : const AuthGate(),
        );
      },
    );
  }
}
