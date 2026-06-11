import 'package:fitness/features/water/add_water_form.dart';
import 'package:fitness/models/water_log_model.dart';
import 'package:fitness/services/auth_service.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Water Intake')),
      body: StreamBuilder<List<WaterLogModel>>(
        stream: firestoreService.getWaterLogs(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_drink, size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  const Text('No water logged yet.'),
                ],
              ),
            );
          }
          final logs = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final log = logs[index];
              return Dismissible(
                key: Key(log.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  firestoreService.deleteWaterLog(user.uid, log.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Water log deleted')));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withValues(alpha: 0.2),
                      child: const Icon(Icons.local_drink, color: Colors.blue),
                    ),
                    title: Text('${log.amountMl} ml', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(DateFormat.yMMMd().add_jm().format(log.timestamp), style: TextStyle(color: Theme.of(context).hintColor)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _showAddWaterSheet(context, user.uid, firestoreService),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showAddWaterSheet(BuildContext context, String uid, FirestoreService service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddWaterForm(uid: uid, service: service),
      ),
    );
  }
}
