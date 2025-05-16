class ExerciseModel {
  final String? id; // Agora o id é opcional
  final String name;
  final String description;
  final String? videoUrl;
  final String? difficulty;
  final String? category;

  ExerciseModel({
    this.id, // Tornado opcional
    required this.name,
    required this.description,
    this.videoUrl,
    this.difficulty,
    this.category,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['_id'] ?? json['id'], // Suporta MongoDB ou outro backend
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'],
      difficulty: json['difficulty'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      if (id != null) 'id': id, // Só inclui o id se não for nulo
      'name': name,
      'description': description,
      'videoUrl': videoUrl,
      'difficulty': difficulty,
      'category': category,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }
}
