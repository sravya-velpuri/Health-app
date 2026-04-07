class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final double height; // in cm
  final double weight; // in kg
  final int dailyStepGoal;
  final int dailyWaterGoal; // in ml
  final int dailyCalorieGoal;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.height = 170.0,
    this.weight = 70.0,
    this.dailyStepGoal = 10000,
    this.dailyWaterGoal = 2500,
    this.dailyCalorieGoal = 2000,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      height: (map['height'] ?? 170.0).toDouble(),
      weight: (map['weight'] ?? 70.0).toDouble(),
      dailyStepGoal: map['dailyStepGoal'] ?? 10000,
      dailyWaterGoal: map['dailyWaterGoal'] ?? 2500,
      dailyCalorieGoal: map['dailyCalorieGoal'] ?? 2000,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'height': height,
      'weight': weight,
      'dailyStepGoal': dailyStepGoal,
      'dailyWaterGoal': dailyWaterGoal,
      'dailyCalorieGoal': dailyCalorieGoal,
    };
  }
}
