class WaterModel {
  final String id;
  final int amountMl;
  final DateTime date;

  WaterModel({
    required this.id,
    required this.amountMl,
    required this.date,
  });

  factory WaterModel.fromMap(Map<String, dynamic> map, String id) {
    return WaterModel(
      id: id,
      amountMl: map['amountMl'] ?? 0,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amountMl': amountMl,
      'date': date.toIso8601String(),
    };
  }
}
