import 'package:flutter/material.dart';
import 'package:fit_yourself/screens/workout/workout_list_screen.dart';
import 'package:fit_yourself/screens/recipe/recipe_screen.dart';
import 'package:fit_yourself/screens/chatbot/chatbot_screen.dart';
import 'package:fit_yourself/screens/auth/profile_screen.dart';
import 'package:fit_yourself/screens/reports/reports_screen.dart'; 
import 'package:fit_yourself/screens/group_chat_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WorkoutListScreen(),
    RecipeScreen(),
    GroupChatScreen(),
    ChatbotScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Workout'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Diet'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'AI Coach'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}