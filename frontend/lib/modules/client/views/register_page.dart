// lib/modules/client/views/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final AuthController authController = Get.find();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final conditionController = TextEditingController();
  final phoneController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar usuário e paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Nome de usuário'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const Divider(),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome completo'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: 'Altura (m)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(labelText: 'Condição médica'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final name = nameController.text.trim();
                final age = int.tryParse(ageController.text.trim()) ?? 0;
                final weight = double.tryParse(weightController.text.trim()) ?? 0.0;
                final height = double.tryParse(heightController.text.trim()) ?? 0.0;
                final condition = conditionController.text.trim();
                final phone = phoneController.text.trim();

                if ([username, email, password, name, phone].any((e) => e.isEmpty)) {
                  Get.snackbar('Erro', 'Preencha todos os campos obrigatórios');
                  return;
                }

                final success = await authController.registerWithPatient(
                  username: username,
                  email: email,
                  password: password,
                  name: name,
                  age: age,
                  weight: weight,
                  height: height,
                  medicalCondition: condition,
                  phone: phone,
                );

                if (success) {
                  Get.offAllNamed('/login');
                } else {
                  Get.snackbar('Erro', 'Falha ao registrar');
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
