import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserListPage extends StatelessWidget {
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    controller.fetchUsers();

    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      body: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
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
                      controller.deleteUser(user.id ?? '');
                      Get.back();
                    },
                  );
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-user'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
