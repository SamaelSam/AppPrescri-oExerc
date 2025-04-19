import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  final box = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final token = box.read('token');

    // Se não houver token, redireciona para o login
    if (token == null || token.isEmpty) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // Caso contrário, continua normalmente
    return null;
  }
}
