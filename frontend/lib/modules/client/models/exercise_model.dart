class ExerciseModel {
  final String? id;
  final String name;
  final String description;
  final int duration;

  ExerciseModel({
    this.id,
    required this.name,
    required this.description,
    required this.duration,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
    };
  }
}
