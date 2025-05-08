import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';

class PatientListPage extends StatelessWidget {
  final PatientController controller = Get.find<PatientController>();

  PatientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchPatients(); // Garantir que os pacientes sejam carregados na tela

    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: Obx(() {
        if (controller.patients.isEmpty) {
          return const Center(child: Text('Nenhum paciente encontrado.'));
        }

        return ListView.builder(
          itemCount: controller.patients.length,
          itemBuilder: (_, index) {
            final p = controller.patients[index];
            return ListTile(
              title: Text(p.name),
              subtitle: Text(p.email), // Ajustado para exibir apenas o e-mail
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Confirmar',
                    middleText: 'Deseja excluir este paciente?',
                    textConfirm: 'Sim',
                    textCancel: 'Não',
                    onConfirm: () async {
                      await controller.deletePatient(p.id!); // ou outro identificador
                      Get.back();
                    },
                  );
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-patient'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
