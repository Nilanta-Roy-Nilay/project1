import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/food_intake_model.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/models/workout_model.dart';
import 'package:fitness/models/step_log_model.dart';
import 'package:fitness/models/water_log_model.dart';
import 'package:fitness/models/chat_log_model.dart';
import 'dart:async';

class FirestoreService {
  late final FirebaseFirestore _db;

  FirestoreService() {
    _db = FirebaseFirestore.instance;
    _initializeFirestore();
  }

  void _initializeFirestore() {
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  bool _isOfflineFirestoreError(Object error) {
    return error is FirebaseException &&
        (error.code == 'unavailable' ||
            error.message?.toLowerCase().contains('offline') == true);
  }

  void _handleFirestoreSnapshotError(Object error) {
    if (!_isOfflineFirestoreError(error)) {
      throw error;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.serverAndCache));

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable' || e.message?.contains('offline') == true) {
        try {
          final doc = await _db
              .collection('users')
              .doc(uid)
              .get(const GetOptions(source: Source.cache));

          if (doc.exists) {
            return UserModel.fromMap(doc.data()!);
          }
          return null;
        } catch (_) {
          return null;
        }
      }
      rethrow;
    }
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    await _db
        .collection('users')
        .doc(workout.userId)
        .collection('workouts')
        .doc(workout.id)
        .set(workout.toMap());
  }

  Future<void> deleteWorkout(String uid, String workoutId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .doc(workoutId)
        .delete();
  }

  Stream<List<WorkoutModel>> getWorkouts(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError(_handleFirestoreSnapshotError)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> logSteps(StepLogModel stepLog) async {
    await _db
        .collection('users')
        .doc(stepLog.userId)
        .collection('steps')
        .doc(stepLog.id)
        .set(stepLog.toMap());
  }

  Future<void> updateTodayStepLog(String uid, int steps) async {
    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final stepLog = StepLogModel(
      id: todayStr,
      userId: uid,
      steps: steps,
      timestamp: now,
    );

    await _db
        .collection('users')
        .doc(uid)
        .collection('steps')
        .doc(todayStr)
        .set(stepLog.toMap());
  }

  Future<void> deleteStepLog(String uid, String logId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('steps')
        .doc(logId)
        .delete();
  }

  Stream<List<StepLogModel>> getSteps(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('steps')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError(_handleFirestoreSnapshotError)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StepLogModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Stream<int> getTodaySteps(String uid) {
    return getSteps(uid).map((logs) {
      final now = DateTime.now();
      final todayLogs = logs.where(
        (log) =>
            log.timestamp.year == now.year &&
            log.timestamp.month == now.month &&
            log.timestamp.day == now.day,
      );
      return todayLogs.fold(0, (total, log) => total + log.steps);
    });
  }

  Future<void> logWater(WaterLogModel waterLog) async {
    await _db
        .collection('users')
        .doc(waterLog.userId)
        .collection('water')
        .doc(waterLog.id)
        .set(waterLog.toMap());
  }

  Future<void> deleteWaterLog(String uid, String logId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('water')
        .doc(logId)
        .delete();
  }

  Stream<List<WaterLogModel>> getWaterLogs(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('water')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError(_handleFirestoreSnapshotError)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WaterLogModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Stream<int> getTodayWater(String uid) {
    return getWaterLogs(uid).map((logs) {
      final now = DateTime.now();
      final todayLogs = logs.where(
        (log) =>
            log.timestamp.year == now.year &&
            log.timestamp.month == now.month &&
            log.timestamp.day == now.day,
      );
      return todayLogs.fold(0, (total, log) => total + log.amountMl);
    });
  }

  // Food Intake Methods
  Future<void> logFood(FoodIntake food) async {
    await _db
        .collection('users')
        .doc(food.userId)
        .collection('food')
        .doc(food.id)
        .set(food.toMap());
  }

  Future<void> deleteFoodLog(String uid, String logId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('food')
        .doc(logId)
        .delete();
  }

  Stream<List<FoodIntake>> getFoodLogs(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('food')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError(_handleFirestoreSnapshotError)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FoodIntake.fromMap(doc.data()))
              .toList(),
        );
  }

  Stream<double> getTodayCaloriesBurned(String uid) {
    return getWorkouts(uid).map((workouts) {
      final now = DateTime.now();
      final todayWorkouts = workouts.where(
        (w) =>
            w.timestamp.year == now.year &&
            w.timestamp.month == now.month &&
            w.timestamp.day == now.day,
      );
      return todayWorkouts.fold(0.0, (total, w) => total + w.caloriesBurned);
    });
  }

  /// Returns a stream of weekly activity data (Mon=0 to Sun=6).
  /// Each value is the total number of workouts for that day of the current week.
  Stream<List<double>> getWeeklyWorkoutData(String uid) {
    return getWorkouts(uid).map((workouts) {
      final now = DateTime.now();
      // Find the start of the week (Monday)
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final weekStart = DateTime(monday.year, monday.month, monday.day);

      // Initialize 7 days with 0
      final List<double> weekData = List.filled(7, 0.0);

      for (final workout in workouts) {
        final workoutDate = DateTime(
          workout.timestamp.year,
          workout.timestamp.month,
          workout.timestamp.day,
        );
        final diff = workoutDate.difference(weekStart).inDays;
        if (diff >= 0 && diff < 7) {
          weekData[diff] += workout.caloriesBurned;
        }
      }
      return weekData;
    });
  }

  Future<void> updateStepGoal(String uid, int goal) async {
    await _db.collection('users').doc(uid).update({'stepGoal': goal});
  }

  Stream<double> getTodayCalories(String uid) {
    return getFoodLogs(uid).map((logs) {
      final now = DateTime.now();
      final todayLogs = logs.where(
        (log) =>
            log.timestamp.year == now.year &&
            log.timestamp.month == now.month &&
            log.timestamp.day == now.day,
      );
      return todayLogs.fold(0.0, (total, log) => total + log.totalCalories);
    });
  }

  // Admin Methods
  Stream<List<UserModel>> getAllUsers() {
    return _db
        .collection('users')
        .snapshots()
        .handleError(_handleFirestoreSnapshotError)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<int> getTotalWorkouts() async {
    int total = 0;
    final users = await _db.collection('users').get();
    for (var user in users.docs) {
      final workouts = await _db
          .collection('users')
          .doc(user.id)
          .collection('workouts')
          .get();
      total += workouts.docs.length;
    }
    return total;
  }

  Future<double> getTotalCalories() async {
    double total = 0;
    final users = await _db.collection('users').get();
    for (var user in users.docs) {
      final foods = await _db
          .collection('users')
          .doc(user.id)
          .collection('food')
          .get();
      for (var food in foods.docs) {
        final foodIntake = FoodIntake.fromMap(food.data());
        total += foodIntake.totalCalories;
      }
    }
    return total;
  }

  Future<int> getTotalSteps() async {
    int total = 0;
    final users = await _db.collection('users').get();
    for (var user in users.docs) {
      final steps = await _db
          .collection('users')
          .doc(user.id)
          .collection('steps')
          .get();
      for (var step in steps.docs) {
        final stepLog = StepLogModel.fromMap(step.data());
        total += stepLog.steps;
      }
    }
    return total;
  }

  // AI Chat History Methods
  Future<void> saveChatLog(ChatLogModel chat) async {
    await _db
        .collection('users')
        .doc(chat.userId)
        .collection('chats')
        .doc(chat.id)
        .set(chat.toMap());
  }

  Future<void> deleteChatLog(String uid, String chatId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .delete();
  }

  Future<void> clearChatHistory(String uid) async {
    final docs = await _db
        .collection('users')
        .doc(uid)
        .collection('chats')
        .get();
    final batch = _db.batch();
    for (var doc in docs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<ChatLogModel>> getChatHistory(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError(_handleFirestoreSnapshotError)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatLogModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
