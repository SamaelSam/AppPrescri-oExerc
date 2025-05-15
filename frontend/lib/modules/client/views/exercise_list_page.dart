import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exercise_controller.dart';
import '../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class ExerciseListPage extends StatelessWidget {
  final ExerciseController controller = Get.find<ExerciseController>();
  final AuthController auth = Get.find<AuthController>();

  ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercícios'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.exercises.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum exercício encontrado.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.exercises.length,
          itemBuilder: (_, index) {
            final e = controller.exercises[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  e.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${e.category ?? 'Sem categoria'} • ${e.difficulty ?? 'Sem dificuldade'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Confirmar',
                      middleText: 'Deseja excluir este exercício?',
                      textConfirm: 'Sim',
                      textCancel: 'Não',
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        if (e.id != null) {
                          await controller.deleteExercise(e.id!);
                          Get.back();
                        }
                      },
                    );
                  },
                ),
                onTap: () {
                  // Pode adicionar navegação para detalhes ou edição se desejar
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.exerciseForm),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
