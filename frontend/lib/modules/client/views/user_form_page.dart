import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class UserFormPage extends StatelessWidget {
  final UserController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Usuário'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Chama o método createUser do UserController
                      await controller.createUser(
                        usernameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                      // Exibe a mensagem de erro, caso ocorra
                      if (controller.errorMessage.isNotEmpty) {
                        // Exibe uma snackbar com a mensagem de erro
                        Get.snackbar('Erro', controller.errorMessage.value,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      } else {
                        // Limpa os campos após salvar
                        usernameController.clear();
                        emailController.clear();
                        passwordController.clear();
                        // Volta para a tela anterior
                        Get.back();
                      }
                    }
                  },
                  child: const Text('Salvar'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
