import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/modules/client/models/schedule_model.dart';

class ScheduleRepository {
  final String baseUrl =
      'http://localhost:8000/schedules'; // ajuste se necessário

  Future<List<ScheduleModel>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar agendamentos');
    }
  }

  Future<ScheduleModel> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return ScheduleModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao buscar agendamento');
    }
  }

  Future<void> create(ScheduleModel schedule) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(schedule.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao criar agendamento');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar agendamento');
    }
  }
}
