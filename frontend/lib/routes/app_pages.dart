import 'package:get/get.dart';
import '../modules/client/views/login_page.dart';
import '../modules/client/views/schedule_list_page.dart';
import '../modules/client/views/schedule_form_page.dart';
import '../modules/client/views/patient_form_page.dart';
import '../modules/client/views/patient_list_page.dart'; 
import '../modules/client/views/exercise_form_page.dart';
import '../modules/client/views/exercise_list_page.dart';
import '../modules/client/views/user_form_page.dart';
import '../modules/client/views/user_list_page.dart'; 
import '../modules/client/views/home_page.dart'; 
import '../modules/client/views/register_page.dart'; 

import '../modules/client/controllers/schedule_controller.dart';
import '../modules/client/controllers/patient_controller.dart';
import '../modules/client/controllers/exercise_controller.dart';
import '../modules/client/controllers/user_controller.dart';
import '../modules/client/views/patient_home_page.dart'; // 

import '../middlewares/auth_middleware.dart';

class AppRoutes {
  static const login = '/login';
  static const scheduleList = '/schedules';
  static const scheduleForm = '/schedules/new';
  static const patientForm = '/patients/new';
  static const patientList = '/patients';
  static const exerciseForm = '/exercises/new';
  static const exerciseList = '/exercises';
  static const userForm = '/users/new';
  static const userList = '/users';
  static const home = '/home';
  static const patientHome = '/patient-home';
  static const register = '/register';
}

final List<GetPage> appPages = [
  GetPage(
    name: AppRoutes.login,
    page: () => LoginPage(),
  ),
  GetPage(
    name: AppRoutes.home,
    page: () => const HomePage(),
    bindings: [
      BindingsBuilder(() {
        Get.put(PatientController());
        Get.put(ExerciseController());
        Get.put(ScheduleController()); // Usado como "Prescrições"
      }),
    ],
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.scheduleList,
    page: () => const ScheduleListPage(),
    bindings: [
      BindingsBuilder(() {
        Get.put(ScheduleController());
        Get.put(ExerciseController());
        Get.put(PatientController());
      }),
    ],
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.scheduleForm,
    page: () => const ScheduleFormPage(),
    bindings: [
      BindingsBuilder(() {
        Get.put(ScheduleController());
        Get.put(UserController());
        Get.put(ExerciseController());
        Get.put(PatientController());
      }),
    ],
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.patientForm,
    page: () => PatientFormPage(),
    binding: BindingsBuilder(() {
      Get.put(PatientController());
    }),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.patientList,
    page: () => PatientListPage(),
    binding: BindingsBuilder(() {
      Get.put(PatientController());
    }),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.exerciseForm,
    page: () => const ExerciseFormPage(),
    binding: BindingsBuilder(() {
      Get.put(ExerciseController());
    }),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.exerciseList,
    page: () => ExerciseListPage(),
    binding: BindingsBuilder(() {
      Get.put(ExerciseController());
    }),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.userForm,
    page: () => UserFormPage(),
    binding: BindingsBuilder(() {
      Get.put(UserController());
    }),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.userList, // NOVA ROTA
    page: () => UserListPage(),
    binding: BindingsBuilder(() {
      Get.put(UserController());
    }),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.patientHome,
    page: () => PatientHomePage(),
    bindings: [
      BindingsBuilder(() {
        Get.put(PatientController());
        Get.put(ScheduleController());
      }),
    ],
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.register,
    page: () => RegisterPage(),
  ),
];
