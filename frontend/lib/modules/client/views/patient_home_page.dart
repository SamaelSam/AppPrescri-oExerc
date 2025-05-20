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
          exerciseController.fetchExercises(),
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

  Widget _buildScheduleCard(ScheduleModel schedule) {
    final formattedDate =
        DateFormat('dd/MM/yyyy – HH:mm').format(schedule.scheduledTime);
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showScheduleDetailPage(schedule),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.fitness_center, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Treino em $formattedDate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: textColor.withOpacity(0.5)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.timer,
                      size: 18, color: textColor.withOpacity(0.7)),
                  const SizedBox(width: 6),
                  Text(
                    '${schedule.durationMinutes} minutos',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.note, size: 18, color: textColor.withOpacity(0.7)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      schedule.notes.isNotEmpty
                          ? schedule.notes
                          : 'Sem notas adicionais',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Treinos')),
      body: Obx(() {
        if (scheduleController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (scheduleController.schedules.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fitness_center_outlined,
                    size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum treino encontrado',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            final email = authController.user.value?.email;
            if (email != null) {
              await scheduleController.fetchSchedulesForPatientByEmail(email);
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: scheduleController.schedules.length,
            itemBuilder: (_, index) {
              final schedule = scheduleController.schedules[index];
              return _buildScheduleCard(schedule);
            },
          ),
        );
      }),
    );
  }
}
