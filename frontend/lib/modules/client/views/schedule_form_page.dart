import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/modules/client/controllers/schedule_controller.dart';

class ScheduleFormPage extends StatelessWidget {
  final ScheduleController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController exerciseIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  ScheduleFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Agendamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: patientIdController,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Converter data e hora para um DateTime válido
                    final date = DateTime.parse(dateController.text);
                    final timeParts = timeController.text.split(':');
                    final time = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      int.parse(timeParts[0]),
                      int.parse(timeParts[1]),
                    );

                    // Chamar o método de criação com os valores apropriados
                    controller.createSchedule(
                      patientIdController.text,
                      exerciseIdController.text,
                      time, // Passando o DateTime completo
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
