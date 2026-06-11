import 'dart:async';
import 'package:fitness/models/step_log_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class StepService {
  final FirestoreService _firestoreService;
  final String _userId;

  StreamSubscription<StepCount>? _stepCountStream;
  int _todaySteps = 0;

  StepService(this._firestoreService, this._userId) {
    _initPedometer();
  }

  Future<void> _initPedometer() async {
    // Request permission
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
      );
    }
  }

  void _onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    final lastSavedDate = prefs.getString('lastSavedDate');
    int initialSteps = prefs.getInt('initialSteps') ?? event.steps;

    // Reset initial step count if it's a new day or device rebooted
    if (lastSavedDate != todayStr || event.steps < initialSteps) {
      initialSteps = event.steps;
      await prefs.setString('lastSavedDate', todayStr);
      await prefs.setInt('initialSteps', initialSteps);
    }

    // Daily steps logic
    int currentDailySteps = event.steps - initialSteps;

    if (currentDailySteps > _todaySteps) {
      _todaySteps = currentDailySteps;
      await _firestoreService.updateTodayStepLog(_userId, _todaySteps);
    }
  }

  void _onStepCountError(Object error) {
    print("Pedometer Error: $error");
  }

  void dispose() {
    _stepCountStream?.cancel();
  }
}
