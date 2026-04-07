class SleepModel {
  final String id;
  final double hours;
  final int quality; // 1-5 scale
  final DateTime date;

  SleepModel({
    required this.id,
    required this.hours,
    required this.quality,
    required this.date,
  });

  factory SleepModel.fromMap(Map<String, dynamic> map, String id) {
    return SleepModel(
      id: id,
      hours: (map['hours'] ?? 0.0).toDouble(),
      quality: map['quality'] ?? 3,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hours': hours,
      'quality': quality,
      'date': date.toIso8601String(),
    };
  }
}
