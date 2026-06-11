// ignore_for_file: dead_null_aware_expression, invalid_null_aware_operator, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/workout_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic> _analyticsData = {};

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if context is mounted and provider exists
      if (!mounted) return;

      final workoutService =
          Provider.of<WorkoutService>(context, listen: false);

      // Safe null check for workouts
      final workouts = workoutService.workouts ?? [];

      _analyticsData = {
        'totalWorkouts': workouts.length,
        'totalCalories': workoutService.calories?.toStringAsFixed(0) ?? '0',
        'totalSteps': workoutService.steps?.toString() ?? '0',
        'totalDistance': workoutService.distance?.toStringAsFixed(2) ?? '0.00',
        'avgHeartRate': workoutService.heartRate?.toString() ?? '72',
        'avgSleep': workoutService.sleep?.toString() ?? '7',
        'weeklyProgress': _calculateWeeklyProgress(workouts, workoutService),
        'monthlyProgress': _calculateMonthlyProgress(workouts, workoutService),
        'workoutHistory': workouts,
      };
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
      });
      debugPrint('Error loading analytics: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _calculateWeeklyProgress(
      List<dynamic> workouts, WorkoutService service) {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));

    int weeklyWorkouts = 0;
    double weeklyCalories = 0;
    int weeklySteps = service.steps ?? 0;

    for (var workout in workouts) {
      if (workout.date.isAfter(lastWeek)) {
        weeklyWorkouts++;
        if (workout.calories != null) {
          weeklyCalories +=
              double.tryParse(workout.calories.replaceAll('kcal', '').trim()) ??
                  0;
        }
      }
    }

    return {
      'workouts': weeklyWorkouts,
      'calories': weeklyCalories.toStringAsFixed(0),
      'steps': weeklySteps,
    };
  }

  Map<String, dynamic> _calculateMonthlyProgress(
      List<dynamic> workouts, WorkoutService service) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);

    int monthlyWorkouts = 0;
    double monthlyCalories = 0;

    for (var workout in workouts) {
      if (workout.date.isAfter(lastMonth)) {
        monthlyWorkouts++;
        if (workout.calories != null) {
          monthlyCalories +=
              double.tryParse(workout.calories.replaceAll('kcal', '').trim()) ??
                  0;
        }
      }
    }

    return {
      'workouts': monthlyWorkouts,
      'calories': monthlyCalories.toStringAsFixed(0),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalyticsData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          if (_isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading analytics data...'),
                ],
              ),
            );
          }

          if (_errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeService.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAnalyticsData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              gradient: themeService.isDarkMode
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey.shade900, Colors.black],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.green.shade50, Colors.white],
                    ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  _buildStatsSection(themeService.isDarkMode),
                  const SizedBox(height: 24),

                  // Progress Section
                  _buildProgressSection(themeService.isDarkMode),
                  const SizedBox(height: 24),

                  // Health Metrics
                  _buildHealthMetricsSection(themeService.isDarkMode),
                  const SizedBox(height: 24),

                  // Recent Workouts
                  _buildRecentWorkoutsSection(themeService.isDarkMode),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildStatCard(
              'Total Workouts',
              _analyticsData['totalWorkouts']?.toString() ?? '0',
              Icons.fitness_center,
              Colors.blue,
              isDarkMode,
            ),
            _buildStatCard(
              'Calories Burned',
              _analyticsData['totalCalories']?.toString() ?? '0',
              Icons.local_fire_department,
              Colors.orange,
              isDarkMode,
            ),
            _buildStatCard(
              'Total Steps',
              _analyticsData['totalSteps']?.toString() ?? '0',
              Icons.directions_walk,
              Colors.green,
              isDarkMode,
            ),
            _buildStatCard(
              'Distance (km)',
              _analyticsData['totalDistance']?.toString() ?? '0',
              Icons.map,
              Colors.purple,
              isDarkMode,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(bool isDarkMode) {
    final weeklyWorkouts =
        (_analyticsData['weeklyProgress']?['workouts'] ?? 0).toInt();
    final monthlyWorkouts =
        (_analyticsData['monthlyProgress']?['workouts'] ?? 0).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProgressBar(
                  'Weekly Goal',
                  weeklyWorkouts,
                  5,
                  isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildProgressBar(
                  'Monthly Goal',
                  monthlyWorkouts,
                  20,
                  isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
      String title, int current, int target, bool isDarkMode) {
    double progress = current / target;
    if (progress > 1) progress = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              '$current / $target',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor:
                isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
            color: Colors.green,
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetricsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health Metrics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Heart Rate',
                '${_analyticsData['avgHeartRate'] ?? '72'} BPM',
                Icons.favorite,
                Colors.red,
                isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Sleep',
                '${_analyticsData['avgSleep'] ?? '7'} hours',
                Icons.bedtime,
                Colors.purple,
                isDarkMode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color, bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentWorkoutsSection(bool isDarkMode) {
    final workouts = _analyticsData['workoutHistory'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Workouts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (workouts.isEmpty)
          Card(
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.fitness_center, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No workouts recorded yet'),
                  SizedBox(height: 4),
                  Text(
                    'Start your fitness journey today!',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workouts.length > 5 ? 5 : workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        const Icon(Icons.fitness_center, color: Colors.green),
                  ),
                  title: Text(
                    workout.title ?? 'Workout',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                      '${workout.duration ?? '0 min'} • ${workout.calories ?? '0 kcal'}'),
                  trailing: Text(
                    workout.date != null
                        ? '${workout.date.day}/${workout.date.month}'
                        : 'No date',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
