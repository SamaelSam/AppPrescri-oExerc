import 'package:get/get.dart';
import '../modules/client/views/login_page.dart';
import '../modules/client/views/schedule_list_page.dart';
import '../modules/client/views/schedule_form_page.dart';
import '../modules/client/views/patient_form_page.dart';
import '../modules/client/views/exercise_form_page.dart';
import '../modules/client/views/user_form_page.dart';

import '../modules/client/controllers/schedule_controller.dart';
import '../modules/client/controllers/patient_controller.dart';
import '../modules/client/controllers/exercise_controller.dart';
import '../modules/client/controllers/user_controller.dart';
import '../modules/client/controllers/auth_controller.dart';

import '../middlewares/auth_middleware.dart';

class AppRoutes {
  static const login = '/login';
  static const scheduleList = '/schedules';
  static const scheduleForm = '/schedules/new';
  static const patientForm = '/patients/new';
  static const exerciseForm = '/exercises/new';
  static const userForm = '/users/new';
}

final List<GetPage> appPages = [
  GetPage(
    name: AppRoutes.login,
    page: () => LoginPage(),
    binding: BindingsBuilder(() {
      Get.put(AuthController());
    }),
  ),
  GetPage(
    name: AppRoutes.scheduleList,
    page: () => ScheduleListPage(),
    bindings: [
      BindingsBuilder(() {
        Get.put(ScheduleController());
        Get.put(AuthController());
      }),
    ],
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.scheduleForm,
    page: () => ScheduleFormPage(),
    bindings: [
      BindingsBuilder(() {
        Get.put(ScheduleController());
        Get.put(UserController());
        Get.put(ExerciseController());
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
    name: AppRoutes.exerciseForm,
    page: () => ExerciseFormPage(),
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
];
