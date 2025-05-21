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

  InputDecoration customDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Informações da Conta",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameController,
                  decoration: customDecoration(
                      'Usuário *', 'Digite seu nome de usuário'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: customDecoration('Email *', 'Digite seu email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: customDecoration('Senha *', 'Digite sua senha'),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                Text(
                  "Informações Pessoais",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: customDecoration(
                      'Nome completo *', 'Digite seu nome completo'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        decoration: customDecoration('Idade', 'Ex: 30'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: weightController,
                        decoration: customDecoration('Peso (kg)', 'Ex: 70.5'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        decoration: customDecoration('Altura (m)', 'Ex: 1.75'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: conditionController,
                  decoration: customDecoration('Condição médica', 'Se houver'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration:
                      customDecoration('Telefone *', 'Digite seu número'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () async {
                    final username = usernameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final name = nameController.text.trim();
                    final age = int.tryParse(ageController.text.trim()) ?? 0;
                    final weight =
                        double.tryParse(weightController.text.trim()) ?? 0.0;
                    final height =
                        double.tryParse(heightController.text.trim()) ?? 0.0;
                    final condition = conditionController.text.trim();
                    final phone = phoneController.text.trim();

                    if ([username, email, password, name, phone]
                        .any((e) => e.isEmpty)) {
                      Get.snackbar(
                          'Erro', 'Preencha todos os campos obrigatórios');
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
        ),
      ),
    );
  }
}
