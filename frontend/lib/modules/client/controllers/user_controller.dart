import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/modules/client/models/user_model.dart'; // Importe o modelo de usuário

class UserController extends GetxController {
  var users = <UserModel>[].obs; // Lista de usuários observável
  var isLoading = false.obs; // Estado de carregamento
  var errorMessage = ''.obs; // Mensagem de erro, se ocorrer

  // URL da sua API (substitua pela URL real)
  final String apiUrl = 'http://127.0.0.1:8000/users'; // para emulador Android

  // Método para buscar usuários
  Future<void> fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = ''; // Limpa a mensagem de erro antes de tentar buscar
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Se a resposta for bem-sucedida, parse os dados
        List<dynamic> data = jsonDecode(response.body);
        users.assignAll(data.map((user) => UserModel.fromJson(user)).toList());
      } else {
        // Se não for bem-sucedida, exiba o erro
        throw Exception('Falha ao carregar usuários');
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      errorMessage.value =
          'Erro ao buscar usuários: $e'; // Define a mensagem de erro
    } finally {
      isLoading.value = false;
    }
  }

  // Método para criar um usuário
  Future<void> createUser(
      String username, String email, String password) async {
    isLoading.value = true;
    errorMessage.value = ''; // Limpa a mensagem de erro antes de tentar criar
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role':
              'user', // O valor de role pode ser dinâmico, dependendo do caso
        }),
      );

      if (response.statusCode == 201) {
        // Se o usuário for criado com sucesso, adicione ele na lista
        users.add(UserModel.fromJson(jsonDecode(response.body)));
      } else {
        throw Exception('Falha ao criar usuário');
      }
    } catch (e) {
      print('Erro ao criar usuário: $e');
      errorMessage.value =
          'Erro ao criar usuário: $e'; // Define a mensagem de erro
    } finally {
      isLoading.value = false;
    }
  }

  // Método para excluir um usuário
  Future<void> deleteUser(String userId) async {
    isLoading.value = true;
    errorMessage.value = ''; // Limpa a mensagem de erro antes de tentar deletar
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$userId'));
      if (response.statusCode == 200) {
        // Se o usuário for deletado com sucesso, remova da lista
        users.removeWhere((user) => user.id == userId);
      } else {
        throw Exception('Falha ao deletar usuário');
      }
    } catch (e) {
      print('Erro ao deletar usuário: $e');
      errorMessage.value =
          'Erro ao deletar usuário: $e'; // Define a mensagem de erro
    } finally {
      isLoading.value = false;
    }
  }
}
