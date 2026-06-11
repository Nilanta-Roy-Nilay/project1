import 'dart:convert';
import 'package:hive/hive.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Box get _workoutBox => Hive.box('workoutBox');
  Box get _dietBox => Hive.box('dietBox');
  Box get _weightBox => Hive.box('weightBox');
  Box get _settingsBox => Hive.box('settingsBox');

  // ─── Workout Methods ───

  Future<void> markWorkoutDayComplete(int day) async {
    final completed = getCompletedWorkoutDays();
    if (!completed.contains(day)) {
      completed.add(day);
      await _workoutBox.put('completedDays', jsonEncode(completed));
    }
    await _workoutBox.put(
        'completedDate_$day', DateTime.now().toIso8601String());
  }

  Future<void> completeWorkoutDay(int day) => markWorkoutDayComplete(day);

  Future<void> removeCompletedWorkoutDay(int day) async {
    final completed = getCompletedWorkoutDays();
    if (completed.contains(day)) {
      completed.remove(day);
      await _workoutBox.put('completedDays', jsonEncode(completed));
    }
    await _workoutBox.delete('completedDate_$day');
  }

  bool isWorkoutDayComplete(int day) {
    return getCompletedWorkoutDays().contains(day);
  }

  List<int> getCompletedWorkoutDays() {
    final data = _workoutBox.get('completedDays');
    if (data == null) return [];
    return List<int>.from(jsonDecode(data));
  }

  DateTime? getWorkoutCompletionDate(int day) {
    final dateStr = _workoutBox.get('completedDate_$day');
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  Future<void> saveExerciseDuration(
      int day, String exerciseName, int seconds) async {
    final durations = getExerciseDurations(day);
    durations[exerciseName] = seconds;
    await _workoutBox.put('durations_$day', jsonEncode(durations));
  }

  Map<String, int> getExerciseDurations(int day) {
    final data = _workoutBox.get('durations_$day');
    if (data == null) return {};
    return Map<String, int>.from(jsonDecode(data));
  }

  Future<void> clearExerciseDuration(int day, String exerciseName) async {
    final durations = getExerciseDurations(day);
    durations.remove(exerciseName);
    await _workoutBox.put('durations_$day', jsonEncode(durations));
  }

  int getWorkoutStreak() {
    final completed = getCompletedWorkoutDays()..sort();
    if (completed.isEmpty) return 0;
    int streak = 1;
    int maxStreak = 1;
    for (int i = 1; i < completed.length; i++) {
      if (completed[i] == completed[i - 1] + 1) {
        streak++;
        if (streak > maxStreak) maxStreak = streak;
      } else {
        streak = 1;
      }
    }
    return maxStreak;
  }

  // ─── Diet Methods ───

  Future<void> markDietDayComplete(int day, String dietType) async {
    final completed = getCompletedDietDays();
    if (!completed.contains(day)) {
      completed.add(day);
      await _dietBox.put('completedDays', jsonEncode(completed));
    }
    await _dietBox.put('dietType_$day', dietType);
    await _dietBox.put('completedDate_$day', DateTime.now().toIso8601String());
  }

  bool isDietDayComplete(int day) {
    return getCompletedDietDays().contains(day);
  }

  List<int> getCompletedDietDays() {
    final data = _dietBox.get('completedDays');
    if (data == null) return [];
    return List<int>.from(jsonDecode(data));
  }

  String? getDietType(int day) {
    return _dietBox.get('dietType_$day');
  }

  DateTime? getDietCompletionDate(int day) {
    final dateStr = _dietBox.get('completedDate_$day');
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  // ─── Weight Methods ───

  Future<void> addWeightEntry(DateTime date, double weight) async {
    final history = getWeightHistory();
    history.add({
      'date': date.toIso8601String(),
      'weight': weight,
    });
    await _weightBox.put('history', jsonEncode(history));
  }

  List<Map<String, dynamic>> getWeightHistory() {
    final data = _weightBox.get('history');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(
      (jsonDecode(data) as List).map((e) => Map<String, dynamic>.from(e)),
    );
  }

  Future<void> deleteWeightEntry(int index) async {
    final history = getWeightHistory();
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await _weightBox.put('history', jsonEncode(history));
    }
  }

  // ─── Profile Methods ───

  Future<void> saveUserProfile({
    double? height,
    double? weight,
    int? age,
    String? gender,
  }) async {
    final profile = getUserProfile();
    if (height != null) profile['height'] = height;
    if (weight != null) profile['weight'] = weight;
    if (age != null) profile['age'] = age;
    if (gender != null) profile['gender'] = gender;
    await _settingsBox.put('profile', jsonEncode(profile));
  }

  Map<String, dynamic> getUserProfile() {
    final data = _settingsBox.get('profile');
    if (data == null) return {};
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  // ─── Step Methods ───
  Future<void> saveTodaySteps(int steps) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    await _settingsBox.put('steps_$today', steps);
  }

  int getSteps(String date) {
    return _settingsBox.get('steps_$date', defaultValue: 0);
  }

  // Activity Session Methods
  Future<void> saveActivitySession({
    required int steps,
    required int duration,
    required String type,
  }) async {
    final sessions = getActivitySessions();
    sessions.insert(0, {
      'steps': steps,
      'duration': duration,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // Keep only last 50 sessions
    if (sessions.length > 50) sessions.removeLast();
    await _settingsBox.put('activity_sessions', jsonEncode(sessions));
  }

  List<Map<String, dynamic>> getActivitySessions() {
    final data = _settingsBox.get('activity_sessions');
    if (data == null) return [];
    try {
      return List<Map<String, dynamic>>.from(
        (jsonDecode(data) as List).map((e) => Map<String, dynamic>.from(e)),
      );
    } catch (e) {
      return [];
    }
  }
}
