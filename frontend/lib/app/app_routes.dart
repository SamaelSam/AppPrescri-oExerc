import 'package:flutter/material.dart';
import 'package:frontend/modules/home/views/home_page.dart';
import 'package:frontend/modules/login/views/login_page.dart';

class AppRoutes {
  static const home = '/home';
  static const login = '/login';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
  };
}
