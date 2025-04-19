import 'package:get/get.dart';
import 'package:frontend/data/repositories/user_repository.dart';
import 'package:frontend/modules/client/models/user_model.dart';

class UserController extends GetxController {
  final UserRepository _repo = UserRepository();

  final RxList<UserModel> users = <UserModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final data = await _repo.getAll();
      users.assignAll(data);
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUser(String username, String email, String password) async {
    final newUser =
        UserModel(username: username, email: email, password: password);
    try {
      await _repo.create(newUser);
      fetchUsers();
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _repo.delete(id);
      fetchUsers();
    } catch (e) {
      print('Erro ao deletar usuário: $e');
    }
  }
}
