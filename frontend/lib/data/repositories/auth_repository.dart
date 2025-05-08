import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modules/client/models/auth_token_model.dart';

class AuthRepository {
  final String baseUrl = 'http://localhost:8000';

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
