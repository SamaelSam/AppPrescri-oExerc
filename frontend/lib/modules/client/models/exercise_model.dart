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
      id: "ex123",
      name: json['name'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      difficulty: json['difficulty'], // Adicionado
      category: json['category'],     // Adicionado
    );
  }

  // Atualizando o método toJson para incluir difficulty e category
  Map<String, dynamic> toJson() {
  final data = {
    'id': "ex123",
    'name': name,
    'description': description,
    'videoUrl': videoUrl,
    'difficulty': difficulty,
    'category': category,
  };

  // Remove campos com valor null
  data.removeWhere((key, value) => value == null);
  return data;
}

}
