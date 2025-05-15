import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';
import '../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class PatientListPage extends StatelessWidget {
  final PatientController controller = Get.find();
  final AuthController auth = Get.find();

  PatientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchPatients(); // Carrega pacientes ao entrar

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.patients.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum paciente encontrado.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.patients.length,
          itemBuilder: (_, index) {
            final p = controller.patients[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  p.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'ID: ${p.id}\n'
                  'Idade: ${p.age} | Peso: ${p.weight}kg | Altura: ${p.height}cm\n'
                  'Condição Médica: ${p.medicalCondition}',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Confirmar',
                      middleText: 'Deseja excluir este paciente?',
                      textConfirm: 'Sim',
                      textCancel: 'Não',
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        if (p.id != null) {
                          await controller.deletePatient(p.id!);
                          Get.back();
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
        onPressed: () => Get.toNamed(AppRoutes.patientForm),
        tooltip: 'Adicionar paciente',
        child: const Icon(Icons.add),
      ),
    );
  }
}
