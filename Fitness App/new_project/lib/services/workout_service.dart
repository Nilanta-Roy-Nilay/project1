// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class WorkoutService extends ChangeNotifier {
  List<Workout> _workouts = []; // Empty list instead of null
  int _steps = 0;
  double _calories = 0;
  double _distance = 0;
  int _waterIntake = 0;
  int _heartRate = 72;
  int _sleep = 7;
  String? _selectedWorkout;
  int _currentDuration = 0;

  List<Workout> get workouts => _workouts; // Always returns a list
  int get steps => _steps;
  double get calories => _calories;
  double get distance => _distance;
  int get waterIntake => _waterIntake;
  int get heartRate => _heartRate;
  int get sleep => _sleep;
  String? get selectedWorkout => _selectedWorkout;

  void refreshData() {
    notifyListeners();
  }

  void selectWorkout(String workout) {
    _selectedWorkout = workout;
    notifyListeners();
  }

  void updateWorkoutDuration(int seconds) {
    _currentDuration = seconds;
    if (_selectedWorkout == 'Running') {
      _calories = seconds * 0.1;
    } else if (_selectedWorkout == 'Cycling') {
      _calories = seconds * 0.08;
    } else if (_selectedWorkout == 'Yoga') {
      _calories = seconds * 0.05;
    }

    _steps = (seconds * 1.5).toInt();
    _distance = seconds * 0.008;
    notifyListeners();
  }

  void endWorkout() {
    if (_selectedWorkout != null && _currentDuration > 0) {
      final workout = Workout(
        id: DateTime.now().toString(),
        title: _selectedWorkout!,
        duration: '${(_currentDuration / 60).toInt()} min',
        calories: '${_calories.toInt()} kcal',
        date: DateTime.now(),
      );
      _workouts.insert(0, workout);
    }
    _selectedWorkout = null;
    _currentDuration = 0;
    notifyListeners();
  }

  void addWater() {
    _waterIntake += 250;
    notifyListeners();
  }

  void logSleep(int hours) {
    _sleep = hours;
    notifyListeners();
  }

  void updateHeartRate(int rate) {
    _heartRate = rate;
    notifyListeners();
  }
}

class Workout {
  final String id;
  final String title;
  final String duration;
  final String calories;
  final DateTime date;

  Workout({
    required this.id,
    required this.title,
    required this.duration,
    required this.calories,
    required this.date,
  });
}
