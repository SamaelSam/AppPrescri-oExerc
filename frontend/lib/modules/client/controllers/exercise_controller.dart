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
  required String id,
  required String name,
  required String description,
  String? videoUrl,
  String? difficulty,
  String? category,
}) async {
  // Criando o objeto ExerciseModel
  final newExercise = ExerciseModel(
    id: id, // O backend irá gerar o ID, não passamos o ID no frontend
    name: name,
    description: description,
    videoUrl: videoUrl,
    difficulty: difficulty,
    category: category,
  );

  try {
    // Passando o objeto ExerciseModel para o repositório
    final createdExercise = await _repo.create(newExercise); 
    exercises.add(createdExercise); // Adicionando o exercício à lista após a criação
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
