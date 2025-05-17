// pages/patient_home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';
import '../controllers/schedule_controller.dart';

class PatientHomePage extends StatelessWidget {
  final PatientController patientController = Get.find();
  final ScheduleController scheduleController = Get.find();

  PatientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes e Agendamentos')),
      body: Column(
        children: [
          // Lista de pacientes
          Expanded(
            child: Obx(() {
              if (patientController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (patientController.patients.isEmpty) {
                return const Center(child: Text('Nenhum paciente cadastrado'));
              }
              return ListView.builder(
                itemCount: patientController.patients.length,
                itemBuilder: (context, index) {
                  final patient = patientController.patients[index];
                  final isSelected = scheduleController.selectedPatientId.value == patient.id;

                  return ListTile(
                    title: Text(patient.name),
                    selected: isSelected,
                    selectedTileColor: Colors.blue.shade100,
                    onTap: () {
                      scheduleController.fetchSchedulesForPatient(patient.id!);
                    },
                  );
                },
              );
            }),
          ),

          const Divider(),

          // Lista de agendamentos do paciente selecionado
          Expanded(
            child: Obx(() {
              if (scheduleController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (scheduleController.schedules.isEmpty) {
                return const Center(child: Text('Nenhum agendamento'));
              }
              return ListView.builder(
                itemCount: scheduleController.schedules.length,
                itemBuilder: (context, index) {
                  final schedule = scheduleController.schedules[index];
                  return ListTile(
                    title: Text('Agendamento em ${schedule.scheduledTime}'),
                    subtitle: Text('Duração: ${schedule.durationMinutes} min'),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
