import 'package:get/get.dart';
import 'package:frontend/data/repositories/patient_repository.dart';
import 'package:frontend/modules/client/models/patient_model.dart';

class PatientController extends GetxController {
  final PatientRepository _repo = PatientRepository();
  final RxList<PatientModel> patients = <PatientModel>[].obs;
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

  // Método para criar um paciente
  Future<void> createPatient(String name, String email, String phone) async {
    final newPatient = PatientModel(
      name: name,
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
