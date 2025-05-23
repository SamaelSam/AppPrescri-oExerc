import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/modules/client/models/schedule_model.dart';

class ScheduleRepository {
  final String baseUrl = 'http://localhost:8000'; // Base da API
  
  Future<List<ScheduleModel>> getByPatientEmail(String email) async {
    final uri = Uri.parse('$baseUrl/schedules/patient').replace(queryParameters: {'email': email});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      print('Erro ao buscar por email: ${response.statusCode} - ${response.body}');
      throw Exception('Erro ao buscar agendamentos pelo email do paciente');
    }
  }

  Future<List<ScheduleModel>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/schedules'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
          json.decode(utf8.decode(response.bodyBytes)); // ✅ UTF-8 aplicado
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar agendamentos');
    }
  }

  Future<ScheduleModel> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/$id'));
    if (response.statusCode == 200) {
      return ScheduleModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes))); // ✅ UTF-8 aplicado
    } else {
      throw Exception('Erro ao buscar agendamento');
    }
  }

  Future<void> create(ScheduleModel schedule) async {
    final jsonBody = schedule.toJson();
    print('JSON enviado para criação do agendamento: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/schedules'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonBody),
    );

    if (response.statusCode != 200) {
      print('Erro na criação: ${response.statusCode} - ${response.body}');
      throw Exception('Erro ao criar agendamento');
    }
  }

  Future<List<ScheduleModel>> getByUserId(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/schedules/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar agendamentos do paciente');
    }
  }

  

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/schedules/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar agendamento');
    }
  }
}
