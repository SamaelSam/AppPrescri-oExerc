import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserListPage extends StatelessWidget {
  final UserController controller = Get.put(
      UserController()); // Garantir que o controller seja instanciado aqui

  UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A primeira execução de fetchUsers ocorre no onInit do controller.
    controller.fetchUsers();

    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: Obx(() {
        // Verifica se o controlador está carregando ou se não há usuários
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text('Nenhum usuário encontrado.'));
        }

        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (_, index) {
            final UserModel user = controller.users[index];
            return ListTile(
              title: Text(user.username),
              subtitle: Text('${user.email} (${user.role})'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Confirmar exclusão',
                    middleText:
                        'Tem certeza que deseja excluir o usuário ${user.username}?',
                    textCancel: 'Cancelar',
                    textConfirm: 'Excluir',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      controller.deleteUser(
                          user.id); // Corrigido para usar o id diretamente
                      Get.back(); // Fecha o dialog
                    },
                  );
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.userForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}
