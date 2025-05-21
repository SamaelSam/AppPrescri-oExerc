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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: requiredField
            ? (value) =>
                value == null || value.isEmpty ? 'Campo obrigatório' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Exercício'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextField(
                    controller: nameController,
                    label: 'Nome',
                    requiredField: true),
                buildTextField(
                    controller: descriptionController,
                    label: 'Descrição',
                    requiredField: true),
                buildTextField(
                    controller: videoUrlController, label: 'URL do vídeo'),
                buildTextField(
                    controller: difficultyController, label: 'Dificuldade'),
                buildTextField(
                    controller: categoryController, label: 'Categoria'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
