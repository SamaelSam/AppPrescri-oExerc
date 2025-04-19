import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
      Get.offAllNamed(AppRoutes.schedules);
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
