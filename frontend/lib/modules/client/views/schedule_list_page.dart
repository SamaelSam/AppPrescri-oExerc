import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/schedule_controller.dart'; // Importando o controlador de agendamentos
import 'package:intl/intl.dart'; // Para formatação de data

class ScheduleListPage extends StatelessWidget {
  final AuthController auth = Get.find();
  final ScheduleController scheduleController =
      Get.find(); // Instanciando o controlador de agendamentos

  ScheduleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Carregar os agendamentos ao inicializar a página
    scheduleController.fetchSchedules();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
            tooltip: 'Sair',
          )
        ],
      ),
      body: Obx(() {
        // Exibir um carregamento enquanto os dados estão sendo carregados
        if (scheduleController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Verifica se a lista de agendamentos está vazia
        if (scheduleController.schedules.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum agendamento encontrado.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        // Exibe a lista de agendamentos
        return ListView.builder(
          itemCount: scheduleController.schedules.length,
          itemBuilder: (_, index) {
            final schedule = scheduleController.schedules[index];

            // Formatar a data de agendamento
            final formattedDate =
                DateFormat('dd/MM/yyyy HH:mm').format(schedule.scheduledTime);

            return Card(
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  elevation: 2,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  child: ListTile(
    title: Text(
      'Usuário: ${schedule.userId}',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text('Exercício: ${schedule.exerciseId}'),
        Text('Notas: ${schedule.notes}'),
        Text('Duração: ${schedule.durationMinutes} minutos'),
        Text('Agendado para: ${schedule.scheduledTime.toLocal().toString()}'),
      ],
    ),
  ),
);

          },
        );
      }),
    );
  }
}
