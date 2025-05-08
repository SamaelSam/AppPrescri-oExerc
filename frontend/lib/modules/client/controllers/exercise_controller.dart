import 'package:get/get.dart';
import 'package:frontend/data/repositories/exercise_repository.dart';
import 'package:frontend/modules/client/models/exercise_model.dart';

class ExerciseController extends GetxController {
  final ExerciseRepository _repo = ExerciseRepository();

  final RxList<ExerciseModel> exercises = <ExerciseModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    isLoading.value = true;
    try {
      final data = await _repo.getAll();
      exercises.assignAll(data);
    } catch (e) {
      print('Erro ao buscar exercícios: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExercise(String name, String description, String? videoUrl) async {
    final newExercise = ExerciseModel(
      name: name,
      description: description,
      videoUrl: videoUrl,
    );
    try {
      await _repo.create(newExercise);
      fetchExercises();
    } catch (e) {
      print('Erro ao adicionar exercício: $e');
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _repo.delete(id);
      fetchExercises();
    } catch (e) {
      print('Erro ao deletar exercício: $e');
    }
  }
}
