import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../data/exercise_data.dart';
import '../../data/storage_service.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int dayNumber;
  final int exerciseIndex;

  const ExerciseDetailScreen({
    super.key,
    required this.dayNumber,
    required this.exerciseIndex,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  final _storage = StorageService();
  final _customController = TextEditingController();

  int _selectedDuration = 30;
  int _timerSeconds = 0;
  bool _timerRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final exercise = _getExercise();
    final durations = _storage.getExerciseDurations(widget.dayNumber);
    final saved = durations[exercise.name];
    if (saved != null && saved > 0) {
      _selectedDuration = saved;
    } else {
      _selectedDuration = exercise.defaultDuration;
    }
    _timerSeconds = _selectedDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _customController.dispose();
    super.dispose();
  }

  dynamic _getExercise() {
    final allDays = ExerciseData.getAllDays();
    final day = allDays.firstWhere((d) => d.dayNumber == widget.dayNumber);
    return day.exercises[widget.exerciseIndex];
  }

  void _startTimer() {
    if (_timerRunning) return;
    setState(() => _timerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds <= 0) {
        timer.cancel();
        setState(() => _timerRunning = false);
        HapticFeedback.heavyImpact();
        _saveAndNotify();
        return;
      }
      setState(() => _timerSeconds--);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _timerRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timerRunning = false;
      _timerSeconds = _selectedDuration;
    });
  }

  Future<void> _saveAndNotify() async {
    final exercise = _getExercise();
    await _storage.saveExerciseDuration(
        widget.dayNumber, exercise.name, _selectedDuration);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Duration saved for ${exercise.name}!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _getExercise();
    final durations = _storage.getExerciseDurations(widget.dayNumber);
    final hasSaved = (durations[exercise.name] ?? 0) > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(exercise.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Visual
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                ),
                child: Center(
                  child: Text(exercise.emoji,
                      style: const TextStyle(fontSize: 72)),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.05, 1.05),
                    duration: 1200.ms,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.05, 1.05),
                    end: const Offset(1.0, 1.0),
                    duration: 1200.ms,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                exercise.name,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  exercise.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Set Duration
            Text(
              'Set Duration',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [15, 30, 45, 60, 90, 120].map((seconds) {
                final isSelected = _selectedDuration == seconds;
                return ChoiceChip(
                  label: Text('${seconds}s'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDuration = seconds;
                      _timerSeconds = seconds;
                      _timerRunning = false;
                      _timer?.cancel();
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Custom (seconds)',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final val = int.tryParse(_customController.text);
                    if (val != null && val >= 5 && val <= 300) {
                      setState(() {
                        _selectedDuration = val;
                        _timerSeconds = val;
                        _timerRunning = false;
                        _timer?.cancel();
                      });
                      FocusScope.of(context).unfocus();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Enter a value between 5 and 300')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(60, 48),
                  ),
                  child: const Text('Set'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Selected: ${_selectedDuration}s',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // How to Perform
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Perform',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...exercise.instructions.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Countdown Timer
            Center(
              child: CircularPercentIndicator(
                radius: 80,
                lineWidth: 8,
                percent: _selectedDuration > 0
                    ? (_timerSeconds / _selectedDuration).clamp(0.0, 1.0)
                    : 0,
                center: Text(
                  '${_timerSeconds}s',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                progressColor: AppColors.accent,
                backgroundColor: AppColors.surface,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _timerRunning ? null : _startTimer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    minimumSize: const Size(100, 42),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _timerRunning ? _pauseTimer : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(100, 42),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(100, 42),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Save / Reset buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveAndNotify,
                    child: const Text('Save Duration'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: hasSaved
                        ? () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: AppColors.card,
                                title: Text('Reset Duration?',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.textPrimary)),
                                content: Text(
                                    'This will clear the saved duration for ${exercise.name}.',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.textSecondary)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel',
                                        style: GoogleFonts.poppins(
                                            color: AppColors.textSecondary)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await _storage.clearExerciseDuration(
                                          widget.dayNumber, exercise.name);
                                      if (mounted) {
                                        Navigator.pop(context);
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Duration reset')));
                                      }
                                    },
                                    child: Text('Reset',
                                        style: GoogleFonts.poppins(
                                            color: AppColors.error)),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
