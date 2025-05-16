import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modules/client/models/patient_model.dart';

class PatientRepository {
  final String baseUrl = 'http://localhost:8000';

  Future<List<Patient>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/patients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)); // 👈 aqui é o fix
      return data.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar pacientes');
    }
  }

  Future<void> create(Patient patient) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao criar paciente');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/patients/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar paciente');
    }
  }
}
