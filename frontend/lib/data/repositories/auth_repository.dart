import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modules/client/models/auth_token_model.dart';

class AuthRepository {
  final String baseUrl = 'http://localhost:8000';

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Erro no registro: ${response.body}');
      return false;
    }
  }

  Future<bool> createPatientFromUser({
    required int userId,
    required String name,
    required String email,
    required int age,
    required double weight,
    required double height,
    required String medicalCondition,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'name': name,
        'email': email,
        'age': age,
        'weight': weight,
        'height': height,
        'medical_condition': medicalCondition,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Erro ao criar paciente: ${response.body}');
      return false;
    }
  }

  Future<AuthToken> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return AuthToken.fromJson(json);
    } else {
      throw Exception('Login inválido');
    }
  }
}
