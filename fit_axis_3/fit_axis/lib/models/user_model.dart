class UserModel {
  final String id;
  final String email;
  final String? name;
  final int? age;
  final String? gender;
  final double? height;
  final double? weight;
  final bool isAdmin;
  final int stepGoal;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.isAdmin = false,
    this.stepGoal = 10000,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'isAdmin': isAdmin,
      'stepGoal': stepGoal,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
      isAdmin: map['isAdmin'] ?? false,
      stepGoal: map['stepGoal'] ?? 10000,
    );
  }
}
