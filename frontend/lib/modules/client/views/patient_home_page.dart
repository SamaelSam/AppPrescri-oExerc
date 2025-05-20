// pages/patient_home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/schedule_controller.dart';
import '../controllers/auth_controller.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final ScheduleController scheduleController = Get.find();
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    // Usa postFrameCallback para chamar após o build inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = authController.user.value?.email;
      if (email != null) {
        scheduleController.fetchSchedulesForPatientByEmail(email);
      }
    });
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
            final formattedTime =
                TimeOfDay.fromDateTime(schedule.scheduledTime).format(context);
            final formattedDateTime =
                '${schedule.scheduledTime.day}/${schedule.scheduledTime.month}/${schedule.scheduledTime.year} às $formattedTime';

            return ListTile(
              title: Text('Agendamento em $formattedDateTime'),
              subtitle: Text(
                  'Duração: ${schedule.durationMinutes} min\nNotas: ${schedule.notes}'),
              isThreeLine: true,
            );
          },
        );
      }),
    );
  }
}
