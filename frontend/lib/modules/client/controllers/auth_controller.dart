import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../models/auth_token_model.dart';
import '../../../routes/app_pages.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final Rxn<AuthToken> token = Rxn<AuthToken>();
  final Rxn<UserModel> user = Rxn<UserModel>();
  bool get isLoggedIn => token.value != null;

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return await _repo.register(
      username: username,
      email: email,
      password: password,
    );
  }

  Future<void> login(String email, String password) async {
    try {
      final AuthToken authToken = await _repo.login(email, password);
      token.value = authToken;
      user.value = authToken.user;

      final box = GetStorage();
      await box.write('token', authToken.accessToken);
      await box.write('user_role', authToken.user.role);

      // Redireciona conforme a role
      if (authToken.user.role == 'admin') {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.patientHome);
      }
    } catch (e) {
      Get.snackbar(
        'Erro no login',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? null : const Color(0xFFB00020),
        colorText: Get.isDarkMode ? null : const Color(0xFFFFFFFF),
      );
    }
  }

  void logout() {
    final box = GetStorage();
    box.remove('token');
    token.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
