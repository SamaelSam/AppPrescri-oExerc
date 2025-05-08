class ExerciseModel {
  final String? id;
  final String name;
  final String description;
  final String? videoUrl;
  final String? difficulty; // Adicionado
  final String? category;  // Adicionado

  ExerciseModel({
    this.id,
    required this.name,
    required this.description,
    this.videoUrl,
    this.difficulty,  // Adicionado
    this.category,    // Adicionado
  });

  // Atualizando o método fromJson para incluir difficulty e category
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      difficulty: json['difficulty'], // Adicionado
      category: json['category'],     // Adicionado
    );
  }

  // Atualizando o método toJson para incluir difficulty e category
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'videoUrl': videoUrl,
      'difficulty': difficulty, // Adicionado
      'category': category,     // Adicionado
    };
  }
}
