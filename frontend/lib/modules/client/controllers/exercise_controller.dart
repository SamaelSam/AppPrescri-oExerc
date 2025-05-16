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

  Future<void> addExercise({
    required String name,
    required String description,
    String? videoUrl,
    String? difficulty,
    String? category,
  }) async {
    final newExercise = ExerciseModel(
      name: name,
      description: description,
      videoUrl: videoUrl,
      difficulty: difficulty,
      category: category,
    );

    try {
      final createdExercise = await _repo.create(newExercise);
      exercises.add(createdExercise);
    } catch (e) {
      print('Erro ao adicionar exercício: $e');
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _repo.delete(id);
      exercises.removeWhere(
          (e) => e.id == id); // remove localmente da lista observável
    } catch (e) {
      print('Erro ao deletar exercício: $e');
    }
  }
}
