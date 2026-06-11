import 'package:fitness/features/admin/admin_dashboard_screen.dart';
import 'package:fitness/features/bmi/bmi_screen.dart';
import 'package:fitness/features/chatbot/chatbot_screen.dart';
import 'package:fitness/features/food/food_tracker_screen.dart';
import 'package:fitness/features/profile/profile_screen.dart';
import 'package:fitness/features/steps/steps_screen.dart';
import 'package:fitness/features/water/water_screen.dart';
import 'package:fitness/features/workouts/workout_list_screen.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/services/auth_service.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            actions: [
              FutureBuilder<UserModel?>(
                future: firestoreService.getUser(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data?.isAdmin == true) {
                    return IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                      ),
                      tooltip: 'Admin Dashboard',
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              IconButton(
                icon: const Icon(Icons.calculate_outlined),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BMICalculatorScreen())),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('No'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Provider.of<AuthService>(context, listen: false).signOut();
                          },
                          child: const Text('Yes', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                const Text('Activity Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Weekly calories burned', style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: StreamBuilder<List<double>>(
                    stream: firestoreService.getWeeklyWorkoutData(user.uid),
                    initialData: const [0, 0, 0, 0, 0, 0, 0],
                    builder: (context, snapshot) {
                      final weekData = snapshot.data ?? [0, 0, 0, 0, 0, 0, 0];
                      final maxVal = weekData.reduce((a, b) => a > b ? a : b);
                      final chartMax = maxVal > 0 ? (maxVal * 1.3).ceilToDouble() : 500.0;
                      final today = DateTime.now().weekday - 1; // 0=Mon, 6=Sun

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: chartMax,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      '${rod.toY.toStringAsFixed(0)} kcal',
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                      final idx = value.toInt();
                                      if (idx < 0 || idx > 6) return const SizedBox.shrink();
                                      final isToday = idx == today;
                                      return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                          days[idx],
                                          style: TextStyle(
                                            color: isToday ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: List.generate(7, (index) {
                                final isToday = index == today;
                                return makeGroupData(
                                  index,
                                  weekData[index],
                                  isToday
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).primaryColor,
                                  chartMax,
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ───── Calorie Balance Summary Card ─────
                const SizedBox(height: 24),
                const Text('Calorie Balance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildCalorieBalanceCard(context, firestoreService, user.uid),

                const SizedBox(height: 24),
                _buildModernCard(
                  context,
                  title: 'Steps',
                  icon: Icons.directions_walk,
                  color: Colors.orange,
                  gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF0080)]),
                  stream: firestoreService.getTodaySteps(user.uid),
                  unit: 'steps',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StepsScreen())),
                ),
                const SizedBox(height: 16),
                _buildModernCard(
                  context,
                  title: 'Water',
                  icon: Icons.local_drink,
                  color: Colors.blue,
                  gradient: const LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF0072FF)]),
                  stream: firestoreService.getTodayWater(user.uid),
                  unit: 'ml',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterScreen())),
                ),
                const SizedBox(height: 16),
                _buildModernCard(
                  context,
                  title: 'Calories',
                  icon: Icons.restaurant,
                  color: Colors.green,
                  gradient: const LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)]),
                  stream: firestoreService.getTodayCalories(user.uid).map((cal) => cal.toInt()),
                  unit: 'kcal',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodTrackerScreen())),
                ),
                const SizedBox(height: 16),
                _buildNavigationCard(
                  context,
                  title: 'Workouts',
                  subtitle: 'Log your exercises',
                  icon: Icons.fitness_center,
                  color: Theme.of(context).primaryColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutListScreen())),
                ),
                const SizedBox(height: 16),
                _buildNavigationCard(
                  context,
                  title: 'AI Fitness Coach',
                  subtitle: 'Get personalized advice',
                  icon: Icons.smart_toy,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen())),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ───── Calorie Balance Card ─────
  Widget _buildCalorieBalanceCard(BuildContext context, FirestoreService service, String uid) {
    return StreamBuilder<double>(
      stream: service.getTodayCalories(uid),
      initialData: 0,
      builder: (context, intakeSnapshot) {
        return StreamBuilder<double>(
          stream: service.getTodayCaloriesBurned(uid),
          initialData: 0,
          builder: (context, burnedSnapshot) {
            final intake = intakeSnapshot.data ?? 0;
            final burned = burnedSnapshot.data ?? 0;
            final remaining = intake - burned;

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E2235), Color(0xFF2A2D45)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Main remaining calories
                  Text(
                    remaining.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: remaining >= 0 ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error,
                    ),
                  ),
                  Text(
                    remaining >= 0 ? 'Remaining kcal' : 'Calorie Deficit kcal',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 20),
                  // Row of intake / burned
                  Row(
                    children: [
                      Expanded(
                        child: _buildCalorieStat(
                          context,
                          icon: Icons.restaurant,
                          label: 'Intake',
                          value: intake.toStringAsFixed(0),
                          color: const Color(0xFF38ef7d),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.white12,
                      ),
                      Expanded(
                        child: _buildCalorieStat(
                          context,
                          icon: Icons.local_fire_department,
                          label: 'Burned',
                          value: burned.toStringAsFixed(0),
                          color: const Color(0xFFFF6B6B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCalorieStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double y, Color color, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxY, color: Colors.white10),
        ),
      ],
    );
  }

  Widget _buildModernCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required LinearGradient gradient,
    required Stream<int> stream,
    required String unit,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: gradient.colors.first.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    StreamBuilder<int>(
                      stream: stream,
                      initialData: 0,
                      builder: (context, snapshot) {
                        return Text(
                          '${snapshot.data} $unit',
                          style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).hintColor)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
