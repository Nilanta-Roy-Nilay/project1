import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/step_counter_service.dart';
import '../../data/storage_service.dart';
import '../../utils/helpers.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StepCounterService _stepService = StepCounterService();
  final StorageService _storage = StorageService();
  
  Timer? _timer;
  StreamSubscription? _sessionSubscription;
  int _secondsElapsed = 0;
  bool _isActive = false;
  int _sessionSteps = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _stepService.initialize();
    _sessionSubscription = _stepService.sessionStepsStream.listen((steps) {
      if (_isActive && mounted) {
        setState(() {
          _sessionSteps = steps;
        });
      }
    });
  }

  void _toggleTracking() {
    setState(() {
      _isActive = !_isActive;
      if (_isActive) {
        _stepService.startSession();
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _resetTracking() {
    setState(() {
      _isActive = false;
      _timer?.cancel();
      _secondsElapsed = 0;
      _sessionSteps = 0;
      _stepService.stopSession();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int mins = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _saveSession() async {
    if (_sessionSteps == 0 && _secondsElapsed == 0) return;

    setState(() => _isActive = false);
    _timer?.cancel();

    try {
      await _storage.saveActivitySession(
        steps: _sessionSteps,
        duration: _secondsElapsed,
        type: 'walking',
      );

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('activity_logs')
            .add({
          'steps': _sessionSteps,
          'duration': _secondsElapsed,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'walking',
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Activity saved successfully!')),
          );
        }
        _resetTracking();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _sessionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: Text(
          'Your Progress',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFFF97316),
          labelColor: const Color(0xFFF97316),
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Activity'),
            Tab(text: 'Calendar'),
            Tab(text: 'Weight'),
            Tab(text: 'BMI'),
            Tab(text: 'BMR'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivityTab(),
          const CalendarTab(),
          const WeightTab(),
          const BMITab(),
          const BMRTab(),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    final int sessionCalories = (_sessionSteps * 0.04).toInt();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepCounterCard(),
          const SizedBox(height: 20),
          // Live Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isActive
                    ? const Color(0xFFF97316).withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                if (_isActive) ...[
                  const Center(
                    child: SizedBox(
                      height: 120,
                      child: WalkingManAnimation(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusItem(Icons.timer, 'Duration', _formatTime(_secondsElapsed)),
                    _buildStatusItem(Icons.directions_run, 'Session Steps', _sessionSteps.toString()),
                    _buildStatusItem(Icons.local_fire_department, 'Kcal', sessionCalories.toString()),
                  ],
                ),
                if (_isActive) ...[
                  const SizedBox(height: 15),
                  const LinearProgressIndicator(
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF97316)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _toggleTracking,
                  icon: Icon(_isActive ? Icons.pause : Icons.play_arrow),
                  label: Text(_isActive ? 'Pause' : 'Start Walking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isActive ? Colors.redAccent : const Color(0xFFF97316),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (!_isActive && (_sessionSteps > 0 || _secondsElapsed > 0))
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSession,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetTracking,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Weekly Progress',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const _WeeklyBarChart(),
          const SizedBox(height: 24),
          Text(
            'Recent Activities',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const _RecentActivityList(),
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFF97316), size: 24),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// --- Activity Tab Components ---

class _StepCounterCard extends StatelessWidget {
  const _StepCounterCard();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settingsBox').listenable(),
      builder: (context, box, child) {
        final today = DateTime.now().toIso8601String().split('T')[0];
        final int steps = box.get('steps_$today', defaultValue: 0) as int;
        final int goal = box.get('daily_goal', defaultValue: 6000) as int;
        final double percent = (steps / goal).clamp(0.0, 1.0);
        final int calories = (steps * 0.04).toInt();

        return Container(
          padding: const EdgeInsets.all(24),
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
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 12.0,
                percent: percent,
                center: const Icon(Icons.directions_walk, size: 40, color: Colors.white),
                progressColor: Colors.white,
                backgroundColor: Colors.white24,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today\'s Steps', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                    Text(
                      steps.toString(),
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Goal: $goal', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                    const Divider(color: Colors.white24, height: 20),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text('$calories kcal', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settingsBox').listenable(),
      builder: (context, box, child) {
        final now = DateTime.now();
        final List<int> weeklySteps = [];
        final List<String> days = [];
        int maxSteps = 1000;

        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final dateStr = date.toIso8601String().split('T')[0];
          final int steps = box.get('steps_$dateStr', defaultValue: 0) as int;
          weeklySteps.add(steps);
          days.add(['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1]);
          if (steps > maxSteps) maxSteps = steps;
        }

        return Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final double heightFactor = weeklySteps[index] / maxSteps;
              final bool isToday = index == 6;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 14,
                    height: (120 * heightFactor).clamp(4.0, 120.0),
                    decoration: BoxDecoration(
                      color: isToday ? const Color(0xFFF97316) : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(days[index], style: GoogleFonts.poppins(color: isToday ? const Color(0xFFF97316) : Colors.grey, fontSize: 12)),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  @override
  Widget build(BuildContext context) {
    final sessions = StorageService().getActivitySessions();
    if (sessions.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('No recent activity', style: GoogleFonts.poppins(color: Colors.grey))));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length > 5 ? 5 : sessions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final date = DateTime.parse(session['timestamp']);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              const Icon(Icons.directions_walk, color: Color(0xFFF97316)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Walking', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(DateFormat('MMM dd, hh:mm a').format(date), style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${session['steps']} steps', style: GoogleFonts.poppins(color: const Color(0xFFF97316), fontWeight: FontWeight.bold)),
                Text('${(session['duration'] / 60).toStringAsFixed(1)} min', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              ]),
            ],
          ),
        );
      },
    );
  }
}

// --- Other Tabs (Calendar, Weight, BMI, BMR) ---

class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final completedWorkouts = storage.getCompletedWorkoutDays();
    final completedDiets = storage.getCompletedDietDays();
    final streak = storage.getWorkoutStreak();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('30-Day Overview', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLegend(const Color(0xFFF97316), 'Workout'),
              const SizedBox(width: 12),
              _buildLegend(const Color(0xFF22C55E), 'Diet'),
              const SizedBox(width: 12),
              _buildLegend(const Color(0xFFEAB308), 'Both'),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: 30,
            itemBuilder: (context, index) {
              final day = index + 1;
              final isWorkout = completedWorkouts.contains(day);
              final isDiet = completedDiets.contains(day);
              Color bgColor = Colors.white.withOpacity(0.1);
              if (isWorkout && isDiet) bgColor = const Color(0xFFEAB308);
              else if (isWorkout) bgColor = const Color(0xFFF97316);
              else if (isDiet) bgColor = const Color(0xFF22C55E);

              return Container(
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text('$day', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold))),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildStatCard('Total Workout Days', '${completedWorkouts.length}/30'),
          _buildStatCard('Total Diet Days', '${completedDiets.length}/30'),
          _buildStatCard('Best Streak', '$streak days'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final text = Helpers.generateProgressText(
                  workoutDays: completedWorkouts.length,
                  dietDays: completedDiets.length,
                  startWeight: null,
                  currentWeight: null,
                  streak: streak,
                );
                Share.share(text);
              },
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share Progress'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF97316),
                side: const BorderSide(color: Color(0xFFF97316)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
    ]);
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.grey[400])),
          Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class WeightTab extends StatefulWidget {
  const WeightTab({super.key});
  @override
  State<WeightTab> createState() => _WeightTabState();
}

class _WeightTabState extends State<WeightTab> {
  final _weightController = TextEditingController();
  final _storage = StorageService();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final history = _storage.getWeightHistory();
    double diff = 0;
    if (history.length >= 2) {
      diff = (history.last['weight'] as double) - (history.first['weight'] as double);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                if (date != null) setState(() => _selectedDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                child: Row(children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(DateFormat('MMM dd').format(_selectedDate), style: GoogleFonts.poppins(color: Colors.white)),
                ]),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: _weightController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'kg', hintStyle: const TextStyle(color: Colors.grey), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: () async {
            final w = double.tryParse(_weightController.text);
            if (w != null) { await _storage.addWeightEntry(_selectedDate, w); _weightController.clear(); setState(() {}); }
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Add')),
        ]),
        const SizedBox(height: 20),
        if (history.isNotEmpty) ...[
          SizedBox(height: 200, child: LineChart(LineChartData(gridData: const FlGridData(show: false), titlesData: const FlTitlesData(show: false), borderData: FlBorderData(show: false), lineBarsData: [LineChartBarData(spots: history.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['weight'] as num).toDouble())).toList(), isCurved: true, color: const Color(0xFFF97316), barWidth: 4, dotData: const FlDotData(show: true))]))),
          const SizedBox(height: 20),
          Text('History', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: history.length, itemBuilder: (context, index) {
            final entry = history[history.length - 1 - index];
            return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(DateFormat('MMM dd, yyyy').format(DateTime.parse(entry['date'])), style: GoogleFonts.poppins(color: Colors.white)),
              Text('${entry['weight']} kg', style: GoogleFonts.poppins(color: const Color(0xFFF97316), fontWeight: FontWeight.bold)),
            ]));
          }),
        ],
      ]),
    );
  }
}

class BMITab extends StatefulWidget {
  const BMITab({super.key});
  @override
  State<BMITab> createState() => _BMITabState();
}

class _BMITabState extends State<BMITab> {
  double _h = 170, _w = 70, _bmi = 24.2;
  String _cat = 'Normal';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
      _buildSlider('Height (cm)', _h, 100, 250, (v) => setState(() => _h = v)),
      _buildSlider('Weight (kg)', _w, 30, 200, (v) => setState(() => _w = v)),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () => setState(() { _bmi = Helpers.calculateBMI(_w, _h); _cat = Helpers.getBMICategory(_bmi); }), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316), minimumSize: const Size(double.infinity, 50)), child: const Text('Calculate BMI')),
      const SizedBox(height: 30),
      Text(_bmi.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFFF97316))),
      Text(_cat, style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
    ]));
  }
  Widget _buildSlider(String l, double v, double min, double max, Function(double) fn) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(color: Colors.white)), Slider(value: v, min: min, max: max, activeColor: const Color(0xFFF97316), onChanged: fn)]);
  }
}

class BMRTab extends StatefulWidget {
  const BMRTab({super.key});
  @override
  State<BMRTab> createState() => _BMRTabState();
}

class _BMRTabState extends State<BMRTab> {
  int _age = 25; double _h = 170, _w = 70, _bmr = 1642; bool _male = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Age', style: TextStyle(color: Colors.white)), Text('$_age', style: const TextStyle(color: Color(0xFFF97316), fontSize: 20, fontWeight: FontWeight.bold))]),
      Slider(value: _age.toDouble(), min: 10, max: 100, activeColor: const Color(0xFFF97316), onChanged: (v) => setState(() => _age = v.toInt())),
      Row(children: [Expanded(child: ElevatedButton(onPressed: () => setState(() => _male = true), style: ElevatedButton.styleFrom(backgroundColor: _male ? const Color(0xFFF97316) : Colors.white10), child: const Text('Male'))), const SizedBox(width: 10), Expanded(child: ElevatedButton(onPressed: () => setState(() => _male = false), style: ElevatedButton.styleFrom(backgroundColor: !_male ? const Color(0xFFF97316) : Colors.white10), child: const Text('Female')))]),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () => setState(() { _bmr = Helpers.calculateBMR(weightKg: _w, heightCm: _h, age: _age, isMale: _male); }), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316), minimumSize: const Size(double.infinity, 50)), child: const Text('Calculate BMR')),
      const SizedBox(height: 30),
      Text('${_bmr.toInt()} kcal/day', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFFF97316))),
    ]));
  }
}

// --- Animation Components ---

class WalkingManAnimation extends StatefulWidget {
  const WalkingManAnimation({super.key});
  @override
  State<WalkingManAnimation> createState() => _WalkingManAnimationState();
}

class _WalkingManAnimationState extends State<WalkingManAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) { return AnimatedBuilder(animation: _controller, builder: (context, child) => CustomPaint(painter: WalkingManPainter(_controller.value), size: const Size(80, 100))); }
}

class WalkingManPainter extends CustomPainter {
  final double animationValue;
  WalkingManPainter(this.animationValue);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF97316)..strokeWidth = 4..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final double centerX = size.width / 2, centerY = size.height / 2;
    canvas.drawCircle(Offset(centerX, centerY - 35), 10, paint);
    canvas.drawLine(Offset(centerX, centerY - 25), Offset(centerX, centerY + 10), paint);
    double walkPhase = animationValue * 2 * math.pi;
    double leftLegAngle = math.sin(walkPhase) * 0.4, rightLegAngle = math.sin(walkPhase + math.pi) * 0.4;
    _drawLimb(canvas, Offset(centerX, centerY + 10), leftLegAngle, 35, paint);
    _drawLimb(canvas, Offset(centerX, centerY + 10), rightLegAngle, 35, paint);
    _drawLimb(canvas, Offset(centerX, centerY - 15), rightLegAngle * 0.8, 25, paint);
    _drawLimb(canvas, Offset(centerX, centerY - 15), leftLegAngle * 0.8, 25, paint);
  }
  void _drawLimb(Canvas canvas, Offset start, double angle, double length, Paint paint) {
    Offset end = Offset(start.dx + length * math.sin(angle), start.dy + length * math.cos(angle));
    canvas.drawLine(start, end, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
