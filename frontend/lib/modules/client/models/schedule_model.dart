class ScheduleModel {
  final String? id;
  final String patientId;
  final String exerciseId;
  final DateTime date;

  ScheduleModel({
    this.id,
    required this.patientId,
    required this.exerciseId,
    required this.date,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['_id'],
      patientId: json['patient_id'],
      exerciseId: json['exercise_id'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'exercise_id': exerciseId,
      'date': date.toIso8601String(),
    };
  }
}
