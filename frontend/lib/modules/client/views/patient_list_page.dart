import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';
import '../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class PatientListPage extends StatelessWidget {
  final PatientController controller = Get.find();
  final AuthController auth = Get.find();

  PatientListPage({super.key}) {
    // Executa fetchPatients depois que o widget for montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPatients();
    });
  }

  Future<void> _goToPatientForm() async {
    final result = await Get.toNamed(AppRoutes.patientForm);
    if (result == true) {
      await controller.fetchPatients();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
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
                        Get.back(); // Fecha o diálogo antes da exclusão
                        print('Iniciando deleção do paciente...');
                        if (p.id != null) {
                          try {
                            await controller.deletePatient(p.id!);
                            print('Paciente deletado com sucesso');

                            await controller
                                .fetchPatients(); // Atualiza a lista
                          } catch (e) {
                            print('Erro ao deletar paciente: $e');
                            Get.snackbar(
                              'Erro',
                              'Erro ao excluir paciente',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.shade600,
                              colorText: Colors.white,
                            );
                          }
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
        heroTag: 'patient_fab',
        onPressed: _goToPatientForm,
        tooltip: 'Adicionar paciente',
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
