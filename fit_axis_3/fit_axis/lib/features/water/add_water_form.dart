
import 'package:fitness/models/water_log_model.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddWaterForm extends StatefulWidget {
  final String uid;
  final FirestoreService service;
  const AddWaterForm({super.key, required this.uid, required this.service});

  @override
  State<AddWaterForm> createState() => _AddWaterFormState();
}

class _AddWaterFormState extends State<AddWaterForm> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Log Water', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount (ml)', prefixIcon: Icon(Icons.local_drink)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                final log = WaterLogModel(
                  id: const Uuid().v4(),
                  userId: widget.uid,
                  amountMl: amount,
                  timestamp: DateTime.now(),
                );
                widget.service.logWater(log);
                Navigator.pop(context);
              }
            },
            child: const Text('Add Water'),
          ),
        ],
      ),
    );
  }
}
