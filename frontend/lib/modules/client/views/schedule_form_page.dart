import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/modules/client/controllers/schedule_controller.dart';
import 'package:frontend/modules/client/controllers/patient_controller.dart';
import 'package:frontend/modules/client/controllers/exercise_controller.dart';

class ScheduleFormPage extends StatefulWidget {
  const ScheduleFormPage({super.key});

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  final ScheduleController scheduleController = Get.find();
  final PatientController patientController = Get.find();
  final ExerciseController exerciseController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedPatientId;
  List<String> selectedExerciseIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patientController.fetchPatients();
      exerciseController.fetchExercises();
    });
  }

  void _showMultiSelectExercises() async {
    final exercises = exerciseController.exercises;
    final List<String> tempSelected = List.from(selectedExerciseIds);

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Selecione os Exercícios'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: exercises.map((exercise) {
                    final isSelected = tempSelected.contains(exercise.id);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(exercise.name),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            tempSelected.add(exercise.id!);
                          } else {
                            tempSelected.remove(exercise.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedExerciseIds = tempSelected;
                });
                Navigator.pop(ctx);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

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
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: selectedPatientId,
                    items: patientController.patients.map((p) {
                      return DropdownMenuItem(
                        value: p.id,
                        child: Text(p.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedPatientId = value),
                    decoration: const InputDecoration(labelText: 'Paciente'),
                    validator: (value) =>
                        value == null ? 'Selecione um paciente' : null,
                  );
                }),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      'Exercícios selecionados: ${selectedExerciseIds.length}'),
                ),
                ElevatedButton(
                  onPressed: _showMultiSelectExercises,
                  child: const Text('Selecionar Exercícios'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: dateController,
                  decoration:
                      const InputDecoration(labelText: 'Data (YYYY-MM-DD)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: durationController,
                  decoration:
                      const InputDecoration(labelText: 'Duração (minutos)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notas'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedExerciseIds.isEmpty) {
                        Get.snackbar(
                            'Erro', 'Selecione pelo menos um exercício');
                        return;
                      }

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

                        scheduleController.createSchedule(
                          userId: selectedPatientId!,
                          exerciseIds: selectedExerciseIds,
                          scheduledTime: scheduledTime,
                          durationMinutes: duration,
                          notes: notes,
                        );

                        Get.back(result: true);  
                      } catch (e) {
                        Get.snackbar('Erro', 'Formato inválido nos campos');
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
