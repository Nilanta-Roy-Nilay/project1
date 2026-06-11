
import 'package:fitness/models/step_log_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddStepForm extends StatefulWidget {
  final String uid;
  final FirestoreService service;
  const AddStepForm({super.key, required this.uid, required this.service});

  @override
  State<AddStepForm> createState() => _AddStepFormState();
}

class _AddStepFormState extends State<AddStepForm> {
  final controller = TextEditingController();

  int get _steps => int.tryParse(controller.text) ?? 0;
  double get _estimatedCalories => _steps * 0.04;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_walk, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 12),
              Text('Log Steps', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of steps',
              prefixIcon: Icon(Icons.directions_walk),
              hintText: 'e.g. 5000',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Calorie Estimate
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _steps > 0 ? Colors.orange.withValues(alpha: 0.1) : theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _steps > 0 ? Colors.orange.withValues(alpha: 0.4) : Colors.white10,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: _steps > 0 ? Colors.orange : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimated Calories', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                    Text(
                      '${_estimatedCalories.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _steps > 0 ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _steps > 0
                ? () {
                    final log = StepLogModel(
                      id: const Uuid().v4(),
                      userId: widget.uid,
                      steps: _steps,
                      timestamp: DateTime.now(),
                    );
                    widget.service.logSteps(log);
                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Add Steps'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
