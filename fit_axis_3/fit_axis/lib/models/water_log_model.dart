import 'package:cloud_firestore/cloud_firestore.dart';

class WaterLogModel {
  final String id;
  final String userId;
  final int amountMl;
  final DateTime timestamp;

  WaterLogModel({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amountMl': amountMl,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory WaterLogModel.fromMap(Map<String, dynamic> map) {
    return WaterLogModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amountMl: map['amountMl'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
