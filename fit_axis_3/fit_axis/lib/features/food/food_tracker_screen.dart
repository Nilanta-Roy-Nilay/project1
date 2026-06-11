import 'package:fitness/features/food/food_input_screen.dart';
import 'package:fitness/models/food_intake_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FoodTrackerScreen extends StatelessWidget {
  const FoodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }

    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FoodInputScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Today's Calories Card
          StreamBuilder<double>(
            stream: firestoreService.getTodayCalories(user.uid),
            initialData: 0,
            builder: (context, snapshot) {
              final calories = snapshot.data ?? 0;
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[700]!, Colors.teal[600]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Today\'s Calories',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      calories.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),

          // Food Logs List
          Expanded(
            child: StreamBuilder<List<FoodIntake>>(
              stream: firestoreService.getFoodLogs(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[600]),
                        const SizedBox(height: 16),
                        Text(
                          'No food logs yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first meal',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  );
                }

                final logs = snapshot.data!;
                final groupedLogs = _groupLogsByDate(logs);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: groupedLogs.length,
                  itemBuilder: (context, index) {
                    final date = groupedLogs.keys.elementAt(index);
                    final dateLogs = groupedLogs[date]!;
                    final totalCalories = dateLogs.fold(0.0, (sum, log) => sum + log.totalCalories);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                _formatDate(date),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${totalCalories.toStringAsFixed(0)} kcal',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...dateLogs.map((log) => _buildFoodLogCard(context, log, firestoreService, user.uid)),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FoodInputScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFoodLogCard(BuildContext context, FoodIntake log, FirestoreService service, String uid) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: const Icon(Icons.restaurant, color: Colors.white),
        ),
        title: Text(log.foodName),
        subtitle: Text(
          '${log.quantity} serving${log.quantity != 1 ? 's' : ''} • ${DateFormat('HH:mm').format(log.timestamp)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${log.totalCalories.toStringAsFixed(0)} kcal',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Food Log'),
                    content: Text('Remove ${log.foodName}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await service.deleteFoodLog(uid, log.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Food log deleted')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<FoodIntake>> _groupLogsByDate(List<FoodIntake> logs) {
    final Map<DateTime, List<FoodIntake>> grouped = {};
    for (final log in logs) {
      final date = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      grouped.putIfAbsent(date, () => []).add(log);
    }
    return grouped;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
}
