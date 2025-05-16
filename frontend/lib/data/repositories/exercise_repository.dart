import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/modules/client/models/exercise_model.dart';

class ExerciseRepository {
  final String baseUrl = 'http://localhost:8000'; // Altere se necessário

  // Buscar todos os exercícios
  Future<List<ExerciseModel>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/exercises'));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((e) => ExerciseModel.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar exercícios');
    }
  }

  // Criar um novo exercício
  Future<ExerciseModel> create(ExerciseModel exercise) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exercises'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(exercise.toJson()), // 👈 aproveita o toJson do model
    );

    if (response.statusCode == 201) {
      return ExerciseModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Erro ao criar exercício: ${response.body}');
    }
  }

  // Deletar exercício por ID
  Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/exercises/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar exercício');
    }
  }
}
