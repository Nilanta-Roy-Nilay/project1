// models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final int height;
  final int weight;
  final DateTime createdAt;
  final int totalWorkouts;
  final int totalMinutes;
  final double totalCalories;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.height = 170,
    this.weight = 70,
    required this.createdAt,
    this.totalWorkouts = 0,
    this.totalMinutes = 0,
    this.totalCalories = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'height': height,
      'weight': weight,
      'createdAt': createdAt,
      'totalWorkouts': totalWorkouts,
      'totalMinutes': totalMinutes,
      'totalCalories': totalCalories,
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      height: map['height'] ?? 170,
      weight: map['weight'] ?? 70,
      createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
      totalWorkouts: map['totalWorkouts'] ?? 0,
      totalMinutes: map['totalMinutes'] ?? 0,
      totalCalories: (map['totalCalories'] ?? 0.0).toDouble(),
    );
  }
}

// Workout Session Model
class WorkoutSession {
  final String id;
  final String userId;
  final String type;
  final int duration; // in seconds
  final double calories;
  final DateTime date;
  final double distance;
  final int steps;

  WorkoutSession({
    required this.id,
    required this.userId,
    required this.type,
    required this.duration,
    required this.calories,
    required this.date,
    this.distance = 0,
    this.steps = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'duration': duration,
      'calories': calories,
      'date': date,
      'distance': distance,
      'steps': steps,
    };
  }

  factory WorkoutSession.fromMap(String id, Map<String, dynamic> map) {
    return WorkoutSession(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      duration: map['duration'] ?? 0,
      calories: (map['calories'] ?? 0.0).toDouble(),
      date: (map['date'] as DateTime?) ?? DateTime.now(),
      distance: (map['distance'] ?? 0.0).toDouble(),
      steps: map['steps'] ?? 0,
    );
  }
}
