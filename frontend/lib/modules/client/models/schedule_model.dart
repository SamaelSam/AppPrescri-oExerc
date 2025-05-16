class ScheduleModel {
  final String? id;
  final String userId; // Id do paciente
  final List<String> exerciseIds; // Lista de IDs de exercícios
  final DateTime scheduledTime;
  final int durationMinutes;
  final String notes;

  ScheduleModel({
    this.id,
    required this.userId,
    required this.exerciseIds,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.notes,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['_id'],
      userId: json['user_id'],
      exerciseIds: List<String>.from(json['exercise_ids'] ?? []),
      scheduledTime: DateTime.parse(json['scheduled_time']),
      durationMinutes: json['duration_minutes'],
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'exercise_ids': exerciseIds,
      'scheduled_time': scheduledTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'notes': notes,
    };
  }
}
