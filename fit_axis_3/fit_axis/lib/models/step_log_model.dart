import 'package:cloud_firestore/cloud_firestore.dart';

class StepLogModel {
  final String id;
  final String userId;
  final int steps;
  final DateTime timestamp;

  /// Estimated calories burned: ~0.04 kcal per step
  double get caloriesBurned => steps * 0.04;

  StepLogModel({
    required this.id,
    required this.userId,
    required this.steps,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'steps': steps,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory StepLogModel.fromMap(Map<String, dynamic> map) {
    return StepLogModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      steps: map['steps'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
