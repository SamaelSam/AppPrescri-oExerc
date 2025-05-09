import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/modules/client/controllers/schedule_controller.dart';

class ScheduleFormPage extends StatelessWidget {
  final ScheduleController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController exerciseIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  ScheduleFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Agendamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: userIdController,
                  decoration: const InputDecoration(labelText: 'ID do Paciente'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: exerciseIdController,
                  decoration: const InputDecoration(labelText: 'ID do Exercício'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Data (YYYY-MM-DD)'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duração (minutos)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notas'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final date = DateTime.parse(dateController.text);
                        final timeParts = timeController.text.split(':');
                        final scheduledTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          int.parse(timeParts[0]),
                          int.parse(timeParts[1]),
                        );
                        final duration = int.parse(durationController.text);
                        final notes = notesController.text;

                        controller.createSchedule(
                          userId: userIdController.text,
                          exerciseId: exerciseIdController.text,
                          scheduledTime: scheduledTime,
                          durationMinutes: duration,
                          notes: notes,
                        );

                        Get.back(); // Volta à tela anterior após salvar
                      } catch (e) {
                        Get.snackbar('Erro', 'Formato inválido nos campos de data, hora ou duração');
                      }
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
