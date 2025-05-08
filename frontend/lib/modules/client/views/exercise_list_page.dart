import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exercise_controller.dart';
import '../../../routes/app_pages.dart'; // ajuste conforme estrutura

class ExerciseListPage extends StatelessWidget {
  final ExerciseController controller = Get.find<ExerciseController>();

  ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercícios'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.exercises.isEmpty) {
          return const Center(child: Text('Nenhum exercício encontrado.'));
        }

        return ListView.builder(
          itemCount: controller.exercises.length,
          itemBuilder: (_, index) {
            final e = controller.exercises[index];
            return ListTile(
              title: Text(e.name),
              subtitle: Text(
                '${e.category ?? 'Sem categoria'} • ${e.difficulty ?? 'Sem dificuldade'}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Confirmar',
                    middleText: 'Deseja excluir este exercício?',
                    textConfirm: 'Sim',
                    textCancel: 'Não',
                    onConfirm: () async {
                      if (e.id != null) {
                        await controller.deleteExercise(e.id!);
                        Get.back();
                      }
                    },
                  );
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.exerciseForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}
