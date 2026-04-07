class WorkoutModel {
  final String id;
  final String title;
  final String category; // e.g. Cardio, Strength, Flexibility
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime date;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.date,
  });

  factory WorkoutModel.fromMap(Map<String, dynamic> map, String id) {
    return WorkoutModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? 'General',
      durationMinutes: map['durationMinutes'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
    };
  }
}
