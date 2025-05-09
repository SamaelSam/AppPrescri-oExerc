class ScheduleModel {
  final String? id;
  final String userId;
  final String exerciseId;
  final DateTime scheduledTime;
  final int durationMinutes;
  final String notes;

  ScheduleModel({
    this.id,
    required this.userId,
    required this.exerciseId,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.notes,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['_id'],
      userId: json['user_id'],
      exerciseId: json['exercise_id'],
      scheduledTime: DateTime.parse(json['scheduled_time']),
      durationMinutes: json['duration_minutes'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'scheduled_time': scheduledTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'notes': notes,
    };
  }
}
