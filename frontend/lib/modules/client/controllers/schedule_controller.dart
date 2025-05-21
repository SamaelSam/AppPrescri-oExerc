import 'package:get/get.dart';
import 'package:frontend/data/repositories/schedule_repository.dart';
import 'package:frontend/modules/client/models/schedule_model.dart';
import 'package:frontend/modules/client/controllers/auth_controller.dart';

class ScheduleController extends GetxController {
  final ScheduleRepository _repo = ScheduleRepository();
  final AuthController authController = Get.find<AuthController>();

  final RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;
  final RxBool isLoading = false.obs;

  // Id do paciente selecionado
  final RxString selectedPatientId = ''.obs;

  Future<void> fetchSchedules() async {
    try {
      isLoading.value = true;
      final data = await _repo.getAll();
      schedules.assignAll(data);
    } catch (e) {
      print('Erro ao buscar agendamentos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Buscar agendamentos de um paciente específico por e-mail
  Future<void> fetchSchedulesForPatientByEmail(String patientEmail) async {
    try {
      isLoading.value = true;

      final currentUserEmail = authController.user.value?.email;

      if (currentUserEmail == null || currentUserEmail != patientEmail) {
        print(
            'Acesso negado: o email do paciente não corresponde ao do usuário logado.');
        schedules.clear();
        return;
      }

      final data = await _repo.getByPatientEmail(patientEmail);
      schedules.assignAll(data);
    } catch (e) {
      print('Erro ao buscar agendamentos por email: $e');
      schedules.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createSchedule({
    required String userId,
    required List<String> exerciseIds,
    required DateTime scheduledTime,
    required int durationMinutes,
    required String notes,
  }) async {
    try {
      final schedule = ScheduleModel(
        userId: userId,
        exerciseIds: exerciseIds,
        scheduledTime: scheduledTime,
        durationMinutes: durationMinutes,
        notes: notes,
      );
      await _repo.create(schedule);
      await fetchSchedules();
    } catch (e) {
      print('Erro ao criar agendamento: $e');
    }
  }

  Future<bool> deleteSchedule(String id) async {
    try {
      await _repo.delete(id);
      schedules.removeWhere((s) => s.id == id);
      schedules.refresh();
      return true;
    } catch (e) {
      print('Erro ao deletar agendamento: $e');
      return false;
    }
  }
}
