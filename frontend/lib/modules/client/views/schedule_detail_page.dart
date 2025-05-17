import 'package:flutter/material.dart';
import '../models/schedule_model.dart';
import '../controllers/exercise_controller.dart';
import '../widgets/schedule_detail_widget.dart';

class ScheduleDetailPage extends StatelessWidget {
  final ScheduleModel schedule;
  final ExerciseController exerciseController;

  const ScheduleDetailPage({
    super.key,
    required this.schedule,
    required this.exerciseController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Agendamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // funciona corretamente agora
        ),
      ),
      body: ScheduleDetailWidget(
        schedule: schedule,
        exerciseController: exerciseController,
      ),
    );
  }
}
