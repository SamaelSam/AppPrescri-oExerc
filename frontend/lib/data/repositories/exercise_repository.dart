import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/modules/client/models/exercise_model.dart';

class ExerciseRepository {
  final String baseUrl = 'http://localhost:8000'; // Altere se necessário

  Future<List<ExerciseModel>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/exercises'));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((e) => ExerciseModel.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar exercícios');
    }
  }

  Future<void> create(ExerciseModel exercise) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exercises'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(exercise.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Falha ao criar exercício');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/exercises/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar exercício');
    }
  }
}
