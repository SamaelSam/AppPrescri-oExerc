import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/modules/client/controllers/exercise_controller.dart';

class ExerciseFormPage extends StatefulWidget {
  const ExerciseFormPage({super.key});

  @override
  State<ExerciseFormPage> createState() => _ExerciseFormPageState();
}

class _ExerciseFormPageState extends State<ExerciseFormPage> {
  final ExerciseController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    videoUrlController.dispose();
    difficultyController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Exercício')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: videoUrlController,
                  decoration: const InputDecoration(
                      labelText: 'URL do vídeo (opcional)'),
                ),
                TextFormField(
                  controller: difficultyController,
                  decoration: const InputDecoration(
                      labelText: 'Dificuldade (opcional)'),
                ),
                TextFormField(
                  controller: categoryController,
                  decoration:
                      const InputDecoration(labelText: 'Categoria (opcional)'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.addExercise(
                        name: nameController.text,
                        description: descriptionController.text,
                        videoUrl: videoUrlController.text.isNotEmpty
                            ? videoUrlController.text
                            : null,
                        difficulty: difficultyController.text.isNotEmpty
                            ? difficultyController.text
                            : null,
                        category: categoryController.text.isNotEmpty
                            ? categoryController.text
                            : null,
                      );
                      Get.back(result: true);
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
