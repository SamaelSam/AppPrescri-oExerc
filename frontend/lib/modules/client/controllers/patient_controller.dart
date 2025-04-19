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
    isLoading.value = true;
    try {
      final data = await _repo.getAll();
      patients.assignAll(data);
    } catch (e) {
      print('Erro ao buscar pacientes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPatient(String name, String email, String phone) async {
    final newPatient = PatientModel(name: name, email: email, phone: phone);
    try {
      await _repo.create(newPatient);
      fetchPatients();
    } catch (e) {
      print('Erro ao adicionar paciente: $e');
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await _repo.delete(id);
      fetchPatients();
    } catch (e) {
      print('Erro ao deletar paciente: $e');
    }
  }
}
