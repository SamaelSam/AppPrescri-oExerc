import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/auth_controller.dart';
import '../controllers/schedule_controller.dart';
import '../controllers/patient_controller.dart';
import '../controllers/exercise_controller.dart';
import '../../../routes/app_pages.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({super.key});

  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  final AuthController auth = Get.find();
  final ScheduleController scheduleController = Get.find();
  final PatientController patientController = Get.find();
  final ExerciseController exerciseController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      scheduleController.fetchSchedules(),
      patientController.fetchPatients(),
      exerciseController.fetchExercises(),
    ]);
    print('Exercícios carregados: ${exerciseController.exercises.length}');
  }

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      'Exercícios:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
                        final success = await scheduleController
                            .deleteSchedule(schedule.id!);
                        if (success) {
                          Get.back();
                          // não precisa setState, GetX atualiza a UI via Obx automaticamente
                        } else {
                          Get.snackbar(
                            'Erro',
                            'Falha ao excluir agendamento.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
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
        heroTag: 'schedule_fab',
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.scheduleForm);
          if (result == true) {
            await scheduleController.fetchSchedules();
            setState(() {});
          }
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Novo agendamento',
        child: const Icon(Icons.add),
      ),
    );
  }
}
