import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Hive ইমপোর্ট নিশ্চিত করুন

class StepCounterService {
  static final StepCounterService _instance = StepCounterService._internal();
  factory StepCounterService() => _instance;
  StepCounterService._internal();

  StreamSubscription<StepCount>? _stepSubscription;
  int _initialSteps = -1;
  int _sessionStartSteps = -1;
  int _sessionSteps = 0;
  int _todayStepsBase = -1;
  bool _isSessionActive = false;

  final _sessionStepsController = StreamController<int>.broadcast();
  Stream<int> get sessionStepsStream => _sessionStepsController.stream;

  final _todayStepsController = StreamController<int>.broadcast();
  Stream<int> get todayStepsStream => _todayStepsController.stream;

  int get sessionSteps => _sessionSteps;

  Future<bool> initialize() async {
    if (kIsWeb) return false;

    bool granted = await requestPermission();
    if (granted) {
      _startListening();
    }
    return granted;
  }

  void startSession() {
    _isSessionActive = true;
    _sessionStartSteps = -1; 
    _sessionSteps = 0;
    _sessionStepsController.add(0);
  }

  void stopSession() {
    _isSessionActive = false;
    _sessionStartSteps = -1;
  }

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.activityRecognition.request();
    if (status.isDenied) {
      status = await Permission.activityRecognition.request();
    }
    return status.isGranted;
  }

  void _startListening() {
    _stepSubscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );
  }

  void _onStepCount(StepCount event) {
    final String today = DateTime.now().toIso8601String().split('T')[0];
    final box = Hive.box('settingsBox');

    // Handle today's steps with persistence
    if (_todayStepsBase == -1) {
      int savedSteps = box.get('steps_$today', defaultValue: 0) as int;
      _todayStepsBase = event.steps - savedSteps;
    }

    int todaySteps = event.steps - _todayStepsBase;
    if (todaySteps < 0) {
      // This happens if sensor resets (e.g. phone reboot)
      _todayStepsBase = event.steps;
      // We don't want to lose already saved steps if possible, 
      // but if the sensor is lower than expected, we assume a reset.
      // For now, let's keep it simple.
    }

    // Session Steps Logic
    if (_isSessionActive) {
        if (_sessionStartSteps == -1) {
          _sessionStartSteps = event.steps;
        }
        _sessionSteps = event.steps - _sessionStartSteps;
        if (_sessionSteps < 0) _sessionSteps = 0;
        _sessionStepsController.add(_sessionSteps);
    }

    // Save and notify
    box.put('steps_$today', todaySteps);
    _todayStepsController.add(todaySteps);

    debugPrint("Current Steps: $todaySteps, Session: $_sessionSteps");
  }

  void _onStepCountError(error) {
    debugPrint('Step Count Error: $error');
  }

  void stopListening() {
    _stepSubscription?.cancel();
  }
}