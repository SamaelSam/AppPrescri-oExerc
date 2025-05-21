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
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os pacientes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

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
      await fetchPatients();
      Get.snackbar(
        'Sucesso',
        'Paciente criado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      print('Erro ao criar paciente: $e');
      Get.snackbar(
        'Erro',
        'Não foi possível criar o paciente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> deletePatient(String id) async {
    print('Chamando o repo para deletar o paciente $id');
    try {
      await _repo.delete(id);
      print('Removendo paciente da lista local');
      patients.removeWhere((p) => p.id == id);
      Get.snackbar(
        'Sucesso',
        'Paciente removido com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      print('Erro no deletePatient: $e');
      Get.snackbar(
        'Erro',
        'Não foi possível excluir o paciente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      rethrow; // importante para que o erro chegue ao onConfirm também
    }
  }
}
