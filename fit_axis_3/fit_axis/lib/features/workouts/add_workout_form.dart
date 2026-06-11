import 'package:fitness/core/workout_database.dart';
import 'package:fitness/models/workout_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddWorkoutForm extends StatefulWidget {
  final String uid;
  final FirestoreService service;
  final double? userWeightKg;
  const AddWorkoutForm({super.key, required this.uid, required this.service, this.userWeightKg});

  @override
  State<AddWorkoutForm> createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final _durationController = TextEditingController();
  WorkoutType? _selectedWorkout;
  bool _isLoading = false;

  double get _estimatedCalories {
    if (_selectedWorkout == null || _durationController.text.isEmpty) return 0;
    final duration = int.tryParse(_durationController.text) ?? 0;
    if (duration <= 0) return 0;
    return _selectedWorkout!.calculateCalories(
      duration,
      weightKg: widget.userWeightKg ?? 70.0,
    );
  }

  void _submit() async {
    if (_selectedWorkout == null || _durationController.text.isEmpty) return;
    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) return;

    setState(() => _isLoading = true);
    try {
      final workout = WorkoutModel(
        id: const Uuid().v4(),
        userId: widget.uid,
        type: _selectedWorkout!.name,
        durationMinutes: duration,
        caloriesBurned: _estimatedCalories,
        timestamp: DateTime.now(),
      );
      await widget.service.addWorkout(workout);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // Handle error silently
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.fitness_center, color: theme.primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Text('Log Workout', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),

          // Workout Type Dropdown
          DropdownButtonFormField<WorkoutType>(
            value: _selectedWorkout,
            decoration: InputDecoration(
              labelText: 'Workout Type',
              prefixIcon: Icon(
                _selectedWorkout?.icon ?? Icons.sports,
                color: _selectedWorkout != null ? theme.primaryColor : null,
              ),
            ),
            dropdownColor: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            items: WorkoutDatabase.workoutTypes.map((workout) {
              return DropdownMenuItem<WorkoutType>(
                value: workout,
                child: Row(
                  children: [
                    Icon(workout.icon, size: 20, color: theme.colorScheme.secondary),
                    const SizedBox(width: 12),
                    Text(workout.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedWorkout = value);
            },
          ),
          const SizedBox(height: 16),

          // Duration Input
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Duration (minutes)',
              prefixIcon: Icon(Icons.timer),
              hintText: 'e.g. 30',
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),

          // Estimated Calories Card
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: _estimatedCalories > 0
                  ? LinearGradient(
                      colors: [theme.colorScheme.secondary.withValues(alpha: 0.2), theme.primaryColor.withValues(alpha: 0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: _estimatedCalories > 0 ? null : theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _estimatedCalories > 0 ? theme.primaryColor.withValues(alpha: 0.5) : Colors.white10,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: _estimatedCalories > 0 ? Colors.orange : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Calories',
                      style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_estimatedCalories.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _estimatedCalories > 0 ? theme.primaryColor : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_selectedWorkout != null) ...[
            const SizedBox(height: 8),
            Text(
              'MET value: ${_selectedWorkout!.metValue} • Weight: ${(widget.userWeightKg ?? 70).toStringAsFixed(0)} kg',
              style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 20),

          // Submit Button
          ElevatedButton(
            onPressed: _isLoading || _estimatedCalories <= 0 ? null : _submit,
            child: _isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Add Workout'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }
}