import 'package:get/get.dart';
import 'package:frontend/data/repositories/schedule_repository.dart';
import 'package:frontend/modules/client/models/schedule_model.dart';

class ScheduleController extends GetxController {
  final ScheduleRepository _repo = ScheduleRepository();

  final RxList<ScheduleModel> schedules = <ScheduleModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSchedules();
  }

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

  Future<void> createSchedule({
    required String userId,
    required List<String> exerciseIds, // lista de exercícios
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
      schedules.refresh(); // FORÇA atualização da UI
      return true;
    } catch (e) {
      print('Erro ao deletar agendamento: $e');
      return false;
    }
  }
}
