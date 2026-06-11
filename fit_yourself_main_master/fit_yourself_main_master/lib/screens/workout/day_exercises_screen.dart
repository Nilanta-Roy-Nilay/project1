import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../data/exercise_data.dart';
import '../../data/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/exercise_card.dart';
import '../../widgets/custom_card.dart';
import 'exercise_detail_screen.dart';

class DayExercisesScreen extends StatefulWidget {
  final int dayNumber;

  const DayExercisesScreen({super.key, required this.dayNumber});

  @override
  State<DayExercisesScreen> createState() => _DayExercisesScreenState();
}

class _DayExercisesScreenState extends State<DayExercisesScreen> {
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    final allDays = ExerciseData.getAllDays();
    final day = allDays.firstWhere((d) => d.dayNumber == widget.dayNumber);
    final durations = _storage.getExerciseDurations(widget.dayNumber);
    final allHaveDuration =
        day.exercises.every((e) => (durations[e.name] ?? 0) > 0);
    final isCompleted = _storage.isWorkoutDayComplete(widget.dayNumber);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Day ${widget.dayNumber} - Workout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Motivational Quote
          CustomCard(
            gradient: LinearGradient(
              colors: [
                AppColors.card,
                AppColors.secondary.withValues(alpha: 0.4),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.format_quote, color: AppColors.accent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppConstants.getQuoteForDay(widget.dayNumber),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            day.title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day.subtitle,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Exercise Cards
          ...day.exercises.asMap().entries.map((entry) {
            final exercise = entry.value;
            final savedDuration = durations[exercise.name];
            return ExerciseCard(
              name: exercise.name,
              emoji: exercise.emoji,
              savedDuration: savedDuration,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseDetailScreen(
                      dayNumber: widget.dayNumber,
                      exerciseIndex: entry.key,
                    ),
                  ),
                );
                setState(() {});
              },
            );
          }),

          const SizedBox(height: 20),

          // Complete Day Button
          if (!isCompleted)
            ElevatedButton(
              onPressed: allHaveDuration
                  ? () async {
                      await _storage.markWorkoutDayComplete(widget.dayNumber);
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: AppColors.card,
                            title: Text(
                              'Day ${widget.dayNumber} Complete!',
                              style: GoogleFonts.poppins(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Great job! You crushed Day ${widget.dayNumber}. Keep pushing forward!',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textSecondary),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Awesome!',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    allHaveDuration ? AppColors.success : AppColors.surface,
                disabledBackgroundColor: AppColors.surface,
              ),
              child: Text(
                allHaveDuration
                    ? 'Complete Day ${widget.dayNumber}'
                    : 'Set duration for all exercises first',
                style: GoogleFonts.poppins(
                  color: allHaveDuration ? Colors.white : AppColors.textSecondary,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    'Day ${widget.dayNumber} Completed!',
                    style: GoogleFonts.poppins(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
