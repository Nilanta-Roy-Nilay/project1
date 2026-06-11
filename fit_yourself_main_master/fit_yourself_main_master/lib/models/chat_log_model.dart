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
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatLogModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatLogModel(
      id: docId,
      userId: map['userId'] ?? '',
      userMessage: map['userMessage'] ?? '',
      aiResponse: map['aiResponse'] ?? '',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
    );
  }
}
