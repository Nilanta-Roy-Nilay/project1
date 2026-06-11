import 'package:fitness/features/steps/add_step_form.dart';
import 'package:fitness/models/step_log_model.dart';
import 'package:fitness/services/auth_service.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen>
    with SingleTickerProviderStateMixin {
  int _stepGoal = 10000;
  late AnimationController _animController;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _loadStepGoal();
  }

  void _loadStepGoal() async {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return;
    final service = Provider.of<FirestoreService>(context, listen: false);
    final userModel = await service.getUser(user.uid);
    if (mounted && userModel != null) {
      setState(() => _stepGoal = userModel.stepGoal);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showGoalDialog(
    BuildContext context,
    String uid,
    FirestoreService service,
  ) {
    final controller = TextEditingController(text: _stepGoal.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.flag, color: Colors.orange),
            SizedBox(width: 8),
            Text('Set Daily Step Goal'),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Steps Goal',
            hintText: 'e.g. 10000',
            prefixIcon: Icon(Icons.directions_walk),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final goal = int.tryParse(controller.text);
              if (goal != null && goal > 0) {
                await service.updateStepGoal(uid, goal);
                if (mounted) {
                  setState(() => _stepGoal = goal);
                }
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Set Step Goal',
            onPressed: () =>
                _showGoalDialog(context, user.uid, firestoreService),
          ),
        ],
      ),
      body: Column(
        children: [
          // ───── Circular Progress Section ─────
          StreamBuilder<int>(
            stream: firestoreService.getTodaySteps(user.uid),
            initialData: 0,
            builder: (context, snapshot) {
              final todaySteps = snapshot.data ?? 0;
              final progress = (todaySteps / _stepGoal).clamp(0.0, 1.0);
              final caloriesBurned = todaySteps * 0.04;

              // Trigger animation
              _animController.forward(from: 0);

              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E2235), Color(0xFF2A2D45)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: AnimatedBuilder(
                        animation: _progressAnim,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _CircularProgressPainter(
                              progress: progress * _progressAnim.value,
                              backgroundColor: Colors.white10,
                              progressColor: progress >= 1.0
                                  ? const Color(0xFF38ef7d)
                                  : const Color(0xFFFF8C00),
                              strokeWidth: 12,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    progress >= 1.0
                                        ? Icons.emoji_events
                                        : Icons.directions_walk,
                                    color: progress >= 1.0
                                        ? const Color(0xFF38ef7d)
                                        : Colors.orange,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$todaySteps',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '/ $_stepGoal steps',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Stats Row
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      runAlignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildStatChip(
                          icon: Icons.local_fire_department,
                          value: '${caloriesBurned.toStringAsFixed(0)} kcal',
                          label: 'Burned',
                          color: Colors.orange,
                        ),
                        _buildStatChip(
                          icon: Icons.flag,
                          value: '${(progress * 100).toStringAsFixed(0)}%',
                          label: 'Progress',
                          color: progress >= 1.0
                              ? const Color(0xFF38ef7d)
                              : theme.colorScheme.secondary,
                        ),
                        _buildStatChip(
                          icon: Icons.directions_walk,
                          value:
                              '${(_stepGoal - todaySteps).clamp(0, _stepGoal)}',
                          label: 'Remaining',
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // ───── Step Logs Header ─────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                const Text(
                  'Step History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Swipe to delete',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),

          // ───── Step Logs List ─────
          Expanded(
            child: StreamBuilder<List<StepLogModel>>(
              stream: firestoreService.getSteps(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 64,
                          color: theme.disabledColor,
                        ),
                        const SizedBox(height: 16),
                        const Text('No steps logged yet.'),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to log your steps',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  );
                }
                final logs = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: logs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Dismissible(
                      key: Key(log.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        firestoreService.deleteStepLog(user.uid, log.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Step log deleted')),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.withValues(
                              alpha: 0.2,
                            ),
                            child: const Icon(
                              Icons.directions_walk,
                              color: Colors.orange,
                            ),
                          ),
                          title: Text(
                            '${log.steps} Steps',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '${log.caloriesBurned.toStringAsFixed(0)} kcal • ${DateFormat.yMMMd().add_jm().format(log.timestamp)}',
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _showAddStepSheet(context, user.uid, firestoreService),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
        ),
      ],
    );
  }

  void _showAddStepSheet(
    BuildContext context,
    String uid,
    FirestoreService service,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddStepForm(uid: uid, service: service),
      ),
    );
  }
}

// ───── Circular Progress Painter ─────
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
