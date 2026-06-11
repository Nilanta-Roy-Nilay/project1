import 'package:flutter/services.dart';

class Helpers {
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (remainingSeconds == 0) {
      return '${minutes}m';
    }
    return '${minutes}m ${remainingSeconds}s';
  }

  static String formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal Weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
  }) {
    if (isMale) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    }
    return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
  }

  static double calculateTDEE(double bmr, double activityMultiplier) {
    return bmr * activityMultiplier;
  }

  static Map<String, double> calculateMacros(double tdee) {
    final proteinCalories = tdee * 0.30;
    final carbCalories = tdee * 0.45;
    final fatCalories = tdee * 0.25;
    return {
      'protein': proteinCalories / 4,
      'carbs': carbCalories / 4,
      'fat': fatCalories / 9,
    };
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static String generateProgressText({
    required int workoutDays,
    required int dietDays,
    required double? startWeight,
    required double? currentWeight,
    required int streak,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('My Fit Yourself Progress:');
    buffer.writeln('$workoutDays/30 Workout Days Completed');
    buffer.writeln('$dietDays/30 Diet Days Completed');
    if (startWeight != null && currentWeight != null) {
      final diff = currentWeight - startWeight;
      final sign = diff >= 0 ? '+' : '';
      buffer.writeln(
          'Weight: ${startWeight.toStringAsFixed(1)}kg -> ${currentWeight.toStringAsFixed(1)}kg ($sign${diff.toStringAsFixed(1)}kg)');
    }
    buffer.writeln('Best Streak: $streak days');
    buffer.writeln('Keep going!');
    return buffer.toString();
  }
}
