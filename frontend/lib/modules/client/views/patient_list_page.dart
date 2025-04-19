import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_controller.dart';

class PatientListPage extends StatelessWidget {
  final PatientController controller = Get.find<PatientController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchPatients();

    return Scaffold(
      appBar: AppBar(title: Text('Pacientes')),
      body: Obx(() {
        if (controller.patients.isEmpty) {
          return Center(child: Text('Nenhum paciente encontrado.'));
        }

        return ListView.builder(
          itemCount: controller.patients.length,
          itemBuilder: (_, index) {
            final p = controller.patients[index];
            return ListTile(
              title: Text(p.name),
              subtitle: Text('${p.age} anos - ${p.email}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Confirmar',
                    middleText: 'Deseja excluir este paciente?',
                    textConfirm: 'Sim',
                    textCancel: 'Não',
                    onConfirm: () async {
                      await controller
                          .deletePatient(p.id!); // ou outro identificador
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
        child: Icon(Icons.add),
      ),
    );
  }
}
