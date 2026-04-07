class MealModel {
  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime date;

  MealModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
  });

  factory MealModel.fromMap(Map<String, dynamic> map, String id) {
    return MealModel(
      id: id,
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      protein: map['protein'] ?? 0,
      carbs: map['carbs'] ?? 0,
      fat: map['fat'] ?? 0,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'date': date.toIso8601String(),
    };
  }
}
