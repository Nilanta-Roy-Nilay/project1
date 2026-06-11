class FoodIntake {
  final String id;
  final String userId;
  final String foodName;
  final double calories;
  final double quantity; // serving size multiplier
  final DateTime timestamp;

  FoodIntake({
    required this.id,
    required this.userId,
    required this.foodName,
    required this.calories,
    required this.quantity,
    required this.timestamp,
  });

  double get totalCalories => calories * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'foodName': foodName,
      'calories': calories,
      'quantity': quantity,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory FoodIntake.fromMap(Map<String, dynamic> map) {
    return FoodIntake(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      foodName: map['foodName'] ?? '',
      calories: (map['calories'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 1).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
