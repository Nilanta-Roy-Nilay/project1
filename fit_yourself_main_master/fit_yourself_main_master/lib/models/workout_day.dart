import 'exercise.dart';

class WorkoutDay {
  final int dayNumber;
  final String title;
  final String subtitle;
  final List<Exercise> exercises;
  final bool isRestDay;

  const WorkoutDay({
    required this.dayNumber,
    required this.title,
    required this.subtitle,
    required this.exercises,
    this.isRestDay = false,
  });

  int get estimatedMinutes => (exercises.fold<int>(
          0, (sum, e) => sum + e.defaultDuration) / 60).ceil();
}
