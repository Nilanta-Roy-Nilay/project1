import 'package:cloud_firestore/cloud_firestore.dart';

class ChatLogModel {
  final String id;
  final String userId;
  final String userMessage;
  final String aiResponse;
  final DateTime timestamp;

  ChatLogModel({
    required this.id,
    required this.userId,
    required this.userMessage,
    required this.aiResponse,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory ChatLogModel.fromMap(Map<String, dynamic> map) {
    return ChatLogModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userMessage: map['userMessage'] ?? '',
      aiResponse: map['aiResponse'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
