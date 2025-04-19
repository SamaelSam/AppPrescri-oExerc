import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ScheduleListPage extends StatelessWidget {
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
            tooltip: 'Sair',
          )
        ],
      ),
      body: Center(
        child: Text(
          'Lista de agendamentos aparecerá aqui',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
