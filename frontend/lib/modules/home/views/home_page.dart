import 'package:flutter/material.dart';
import 'package:frontend/modules/home/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Text('Bem-vindo(a) ao Exercise App!\n'
            'Usuários logados podem ver conteúdos aqui.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
