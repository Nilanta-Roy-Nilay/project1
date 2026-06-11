import 'package:fitness/models/user_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Admin Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Administrator Panel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'System Analytics & User Management',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statistics Cards
            const Text(
              'System Statistics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Total Users
            StreamBuilder<List<UserModel>>(
              stream: firestoreService.getAllUsers(),
              builder: (context, snapshot) {
                final userCount = snapshot.data?.length ?? 0;
                return _buildStatCard(
                  context,
                  title: 'Total Users',
                  value: userCount.toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                );
              },
            ),
            const SizedBox(height: 12),

            // Total Workouts
            FutureBuilder<int>(
              future: firestoreService.getTotalWorkouts(),
              builder: (context, snapshot) {
                final workoutCount = snapshot.data ?? 0;
                return _buildStatCard(
                  context,
                  title: 'Total Workouts Logged',
                  value: workoutCount.toString(),
                  icon: Icons.fitness_center,
                  color: Colors.orange,
                );
              },
            ),
            const SizedBox(height: 12),

            // Total Calories
            FutureBuilder<double>(
              future: firestoreService.getTotalCalories(),
              builder: (context, snapshot) {
                final calories = snapshot.data ?? 0;
                return _buildStatCard(
                  context,
                  title: 'Total Calories Tracked',
                  value: '${calories.toStringAsFixed(0)} kcal',
                  icon: Icons.restaurant,
                  color: Colors.green,
                );
              },
            ),
            const SizedBox(height: 12),

            // Total Steps
            FutureBuilder<int>(
              future: firestoreService.getTotalSteps(),
              builder: (context, snapshot) {
                final steps = snapshot.data ?? 0;
                return _buildStatCard(
                  context,
                  title: 'Total Steps Logged',
                  value: steps.toString(),
                  icon: Icons.directions_walk,
                  color: Colors.purple,
                );
              },
            ),

            const SizedBox(height: 32),

            // User List
            const Text(
              'Registered Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            StreamBuilder<List<UserModel>>(
              stream: firestoreService.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text('No users found'),
                      ),
                    ),
                  );
                }

                final users = snapshot.data!;
                return Column(
                  children: users.map((user) => _buildUserCard(context, user)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user.isAdmin ? Colors.deepPurple : Colors.blue,
          child: Icon(
            user.isAdmin ? Icons.admin_panel_settings : Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(user.name ?? 'No Name'),
        subtitle: Text(user.email),
        trailing: user.isAdmin
            ? Chip(
                label: const Text('Admin', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.deepPurple,
              )
            : null,
      ),
    );
  }
}
