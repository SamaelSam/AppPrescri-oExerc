import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exercise_controller.dart';

class ExerciseListPage extends StatelessWidget {
  final ExerciseController controller = Get.find<ExerciseController>();

  @override
  Widget build(BuildContext context) {
    // Garante que os dados sejam buscados ao abrir a tela
    controller.fetchExercises();

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios'),
      ),
      body: Obx(() {
        // Caso você deseje exibir um carregando, adicione isLoading no controller
        if (controller.exercises.isEmpty) {
          return Center(child: Text('Nenhum exercício encontrado.'));
        }

        return ListView.builder(
          itemCount: controller.exercises.length,
          itemBuilder: (_, index) {
            final e = controller.exercises[index];
            return ListTile(
              title: Text(e.name),
              subtitle:
                  Text('${e.category ?? 'Sem categoria'} • ${e.difficulty}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Confirmar',
                    middleText: 'Deseja excluir este exercício?',
                    textConfirm: 'Sim',
                    textCancel: 'Não',
                    onConfirm: () async {
                      await controller
                          .deleteExercise(e.id!); // ou outro identificador
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
        onPressed: () => Get.toNamed('/add-exercise'),
        child: Icon(Icons.add),
      ),
    );
  }
}
