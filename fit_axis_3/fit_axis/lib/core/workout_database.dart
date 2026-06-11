import 'package:flutter/material.dart';

class WorkoutType {
  final String name;
  final double metValue;
  final IconData icon;

  const WorkoutType({
    required this.name,
    required this.metValue,
    required this.icon,
  });

  /// Calories = MET × weight(kg) × duration(hours)
  double calculateCalories(int durationMinutes, {double weightKg = 70.0}) {
    return metValue * weightKg * (durationMinutes / 60.0);
  }
}

class WorkoutDatabase {
  static const List<WorkoutType> workoutTypes = [
    WorkoutType(name: 'Running', metValue: 9.8, icon: Icons.directions_run),
    WorkoutType(name: 'Walking', metValue: 3.5, icon: Icons.directions_walk),
    WorkoutType(name: 'Weight Lifting', metValue: 6.0, icon: Icons.fitness_center),
    WorkoutType(name: 'Squats', metValue: 5.0, icon: Icons.accessibility_new),
    WorkoutType(name: 'Cycling', metValue: 7.5, icon: Icons.directions_bike),
    WorkoutType(name: 'Swimming', metValue: 8.0, icon: Icons.pool),
    WorkoutType(name: 'Yoga', metValue: 3.0, icon: Icons.self_improvement),
    WorkoutType(name: 'Jump Rope', metValue: 12.3, icon: Icons.sports),
    WorkoutType(name: 'HIIT', metValue: 8.0, icon: Icons.flash_on),
    WorkoutType(name: 'Stretching', metValue: 2.3, icon: Icons.sports_gymnastics),
    WorkoutType(name: 'Plank', metValue: 3.8, icon: Icons.straighten),
    WorkoutType(name: 'Push-ups', metValue: 8.0, icon: Icons.sports_martial_arts),
    WorkoutType(name: 'Dancing', metValue: 5.5, icon: Icons.music_note),
    WorkoutType(name: 'Hiking', metValue: 6.0, icon: Icons.terrain),
    WorkoutType(name: 'Boxing', metValue: 7.8, icon: Icons.sports_mma),
  ];

  static WorkoutType? getByName(String name) {
    try {
      return workoutTypes.firstWhere(
        (w) => w.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
