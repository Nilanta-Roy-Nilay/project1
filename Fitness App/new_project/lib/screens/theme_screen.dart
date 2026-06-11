// lib/screens/theme_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildThemeOption(
            context,
            'Light Theme',
            'Bright and clean interface',
            Icons.light_mode,
            Colors.amber,
            ThemeMode.light,
            themeService.themeMode == ThemeMode.light,
          ),
          _buildThemeOption(
            context,
            'Dark Theme',
            'Easy on eyes, saves battery',
            Icons.dark_mode,
            Colors.indigo,
            ThemeMode.dark,
            themeService.themeMode == ThemeMode.dark,
          ),
          _buildThemeOption(
            context,
            'System Default',
            'Follow device theme',
            Icons.settings,
            Colors.blue,
            ThemeMode.system,
            themeService.themeMode == ThemeMode.system,
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.color_lens, size: 48, color: Colors.green),
                const SizedBox(height: 12),
                const Text(
                  'Custom Theme Coming Soon!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'More theme options will be available in future updates.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    ThemeMode themeMode,
    bool isSelected,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        onTap: () {
          context.read<ThemeService>().setThemeMode(themeMode);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title applied!')),
          );
        },
      ),
    );
  }
}

extension on ThemeService {
  void setThemeMode(ThemeMode themeMode) {}
}
