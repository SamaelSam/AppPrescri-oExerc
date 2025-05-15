import 'package:get/get.dart';
import 'package:frontend/data/repositories/patient_repository.dart';
import 'package:frontend/modules/client/models/patient_model.dart';

class PatientController extends GetxController {
  final PatientRepository _repo = PatientRepository();
  final RxList<Patient> patients = <Patient>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      isLoading.value = true;
      final data = await _repo.getAll();
      patients.assignAll(data);
    } catch (e) {
      print('Erro ao buscar pacientes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método atualizado para criar um paciente com todos os campos
  Future<void> createPatient({
    required String name,
    required int age,
    required double weight,
    required double height,
    required String medicalCondition,
    required String email,
    required String phone,
  }) async {
    final newPatient = Patient(
      name: name,
      age: age,
      weight: weight,
      height: height,
      medicalCondition: medicalCondition,
      email: email,
      phone: phone,
    );

    try {
      await _repo.create(newPatient);
      fetchPatients();
    } catch (e) {
      print('Erro ao criar paciente: $e');
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await _repo.delete(id);
      patients.removeWhere((p) => p.id == id);
    } catch (e) {
      print('Erro ao deletar paciente: $e');
    }
  }
}
