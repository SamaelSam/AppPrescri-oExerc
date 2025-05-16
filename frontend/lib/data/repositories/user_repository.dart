import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modules/client/models/user_model.dart';

class UserRepository {
  final String baseUrl = 'http://localhost:8000';

  Future<List<UserModel>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar usuários');
    }
  }

  Future<void> create(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao criar usuário');
    }
  }

  Future<void> delete(String email) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$email'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar usuário');
    }
  }
}
