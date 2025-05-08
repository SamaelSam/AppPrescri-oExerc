class ScheduleModel {
  final String? id;
  final String patientId;
  final String exerciseId;
  final DateTime scheduledAt;

  ScheduleModel({
    this.id,
    required this.patientId,
    required this.exerciseId,
    required this.scheduledAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      patientId: json['patientId'],
      exerciseId: json['exerciseId'],
      scheduledAt: DateTime.parse(json['scheduledAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'exerciseId': exerciseId,
      'scheduledAt': scheduledAt.toIso8601String(),
    };
  }
}
