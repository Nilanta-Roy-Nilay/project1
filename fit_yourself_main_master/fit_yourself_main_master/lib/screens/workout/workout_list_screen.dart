import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../data/exercise_data.dart';
import '../../data/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/day_card.dart';
import 'day_exercises_screen.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final _storage = StorageService();
  late final _allDays = ExerciseData.getAllDays();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCombinedDashboard(),
            const SizedBox(height: 24),
            Text(
              '30-Day Transformation',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildDaysList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedDashboard() {
    final completedWorkouts = _storage.getCompletedWorkoutDays();
    final completedDiets = _storage.getCompletedDietDays();
    final weightHistory = _storage.getWeightHistory();
    final workoutPercent = (completedWorkouts.length / 30).clamp(0.0, 1.0);
    final dietPercent = (completedDiets.length / 30).clamp(0.0, 1.0);
    
    String currentWeight = "--";
    if (weightHistory.isNotEmpty) {
      currentWeight = "${weightHistory.last['weight']} kg";
    }

    return Column(
      children: [
        // Today's Steps Card
        ValueListenableBuilder(
          valueListenable: Hive.box('settingsBox').listenable(),
          builder: (context, box, child) {
            final today = DateTime.now().toIso8601String().split('T')[0];
            final int steps = box.get('steps_$today', defaultValue: 0) as int;
            final int goal = box.get('daily_goal', defaultValue: 6000) as int;
            final double stepPercent = (steps / goal).clamp(0.0, 1.0);
            final int kcal = (steps * 0.04).toInt();

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF97316).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 8.0,
                    percent: stepPercent,
                    center: const Icon(Icons.directions_walk, color: Colors.white, size: 30),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white24,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Steps',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          '$steps',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '$kcal kcal burned',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0);
          },
        ),
        const SizedBox(height: 16),
        // Combined Progress Row (Workout & Diet)
        Row(
          children: [
            Expanded(
              child: _buildSmallProgressCard(
                'Workout',
                '${completedWorkouts.length}/30 Days',
                workoutPercent,
                const Color(0xFFF97316),
                Icons.fitness_center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallProgressCard(
                'Diet',
                '${completedDiets.length}/30 Days',
                dietPercent,
                const Color(0xFF22C55E),
                Icons.restaurant,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 12),
        // Weight Mini Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.monitor_weight_outlined, color: Colors.blueAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Current Weight',
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Text(
                currentWeight,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildSmallProgressCard(String title, String value, double percent, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildDaysList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _allDays.length,
      itemBuilder: (context, index) {
        final day = _allDays[index];
        final isCompleted = _storage.isWorkoutDayComplete(day.dayNumber);
        return DayCard(
          dayNumber: day.dayNumber,
          title: day.title,
          subtitle: '${day.exercises.length} Exercises - ~${day.estimatedMinutes} min',
          isCompleted: isCompleted,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DayExercisesScreen(dayNumber: day.dayNumber),
              ),
            );
            setState(() {});
          },
          onToggleComplete: () async {
            if (isCompleted) {
              await _storage.removeCompletedWorkoutDay(day.dayNumber);
            } else {
              await _storage.completeWorkoutDay(day.dayNumber);
            }
            setState(() {});
          },
        ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1, end: 0);
      },
    );
  }
}
