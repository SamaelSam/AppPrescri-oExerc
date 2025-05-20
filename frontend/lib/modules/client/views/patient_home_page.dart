import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/schedule_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/exercise_controller.dart';
import '../views/schedule_detail_page.dart';
import '../models/schedule_model.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final ScheduleController scheduleController = Get.find();
  final AuthController authController = Get.find();
  final ExerciseController exerciseController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final email = authController.user.value?.email;
      if (email != null) {
        await Future.wait([
          scheduleController.fetchSchedulesForPatientByEmail(email),
          exerciseController.fetchExercises(), // necessário para detalhes
        ]);
      }
    });
  }

  void _showScheduleDetailPage(ScheduleModel schedule) {
    Get.to(() => ScheduleDetailPage(
          schedule: schedule,
          exerciseController: exerciseController,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Agendamentos')),
      body: Obx(() {
        if (scheduleController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (scheduleController.schedules.isEmpty) {
          return const Center(child: Text('Nenhum agendamento encontrado'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: scheduleController.schedules.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final schedule = scheduleController.schedules[index];
            final formattedDate =
                DateFormat('dd/MM/yyyy – HH:mm').format(schedule.scheduledTime);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text('Agendamento em $formattedDate'),
                subtitle: Text(
                  'Duração: ${schedule.durationMinutes} min\nNotas: ${schedule.notes}',
                ),
                isThreeLine: true,
                onTap: () => _showScheduleDetailPage(schedule),
              ),
            );
          },
        );
      }),
    );
  }
}
