import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../models/auth_token_model.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final Rxn<AuthToken> token = Rxn<AuthToken>();

  bool get isLoggedIn => token.value != null;

  Future<void> login(String email, String password) async {
  try {
    final AuthToken auth = await _repo.login(email, password);
    token.value = auth;

    final box = GetStorage();
    box.write('token', auth.accessToken); // ← salva o token

    print("Login bem-sucedido, token: ${auth.accessToken}");
    print("Token setado no controlador: ${token.value?.accessToken}");

    Get.offAllNamed(AppRoutes.exerciseList); // ← redireciona
  } catch (e) {
    Get.snackbar(
      'Erro de login',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}





  void logout() {
    token.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
