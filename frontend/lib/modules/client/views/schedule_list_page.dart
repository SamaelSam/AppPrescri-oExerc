import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../controllers/auth_controller.dart';
import '../controllers/schedule_controller.dart';
import '../controllers/patient_controller.dart';
import '../controllers/exercise_controller.dart';
import '../../../routes/app_pages.dart';

class ScheduleListPage extends StatelessWidget {
  final AuthController auth = Get.find();
  final ScheduleController scheduleController = Get.find();
  final PatientController patientController = Get.find();
  final ExerciseController exerciseController = Get.find();

  ScheduleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Carrega todos os dados ao iniciar
    scheduleController.fetchSchedules();
    patientController.fetchPatients();
    exerciseController.fetchExercises();
    print('Exercícios carregados: ${exerciseController.exercises.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Obx(() {
        if (scheduleController.isLoading.value ||
            patientController.isLoading.value ||
            exerciseController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (scheduleController.schedules.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum agendamento encontrado.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: scheduleController.schedules.length,
          itemBuilder: (_, index) {
            final schedule = scheduleController.schedules[index];
            print('IDs dos exercícios no agendamento: ${schedule.exerciseIds}');
            final formattedDate =
                DateFormat('dd/MM/yyyy HH:mm').format(schedule.scheduledTime);

            final patient = patientController.patients.firstWhereOrNull(
              (p) => p.id == schedule.userId,
            );
            final patientName = patient?.name ?? 'Paciente desconhecido';

            // Exercícios como lista de widgets para melhor visualização
            final exerciseWidgets = schedule.exerciseIds.map((exId) {
              final exercise = exerciseController.exercises
                  .firstWhereOrNull((e) => e.id == exId);
              final name = exercise?.name ?? 'Exercício desconhecido';
              return Text('• $name');
            }).toList();

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  'Paciente: $patientName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const Text('Exercícios:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    ...exerciseWidgets,
                    Text('Notas: ${schedule.notes}'),
                    Text('Duração: ${schedule.durationMinutes} minutos'),
                    Text('Agendado para: $formattedDate'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Excluir agendamento',
                  onPressed: () {
                    if (schedule.id == null) {
                      Get.snackbar(
                        'Erro',
                        'ID do agendamento não encontrado. Não é possível excluir.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    Get.defaultDialog(
                      title: 'Confirmar exclusão',
                      middleText: 'Deseja realmente excluir este agendamento?',
                      textConfirm: 'Excluir',
                      textCancel: 'Cancelar',
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        await scheduleController.deleteSchedule(schedule.id!);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed(AppRoutes.scheduleForm);
          scheduleController.fetchSchedules();
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Novo agendamento',
        child: const Icon(Icons.add),
      ),
    );
  }
}
