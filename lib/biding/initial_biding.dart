import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/auth_controller.dart';
import 'package:new_fun_sphere/controller/checkin_controller.dart';
import 'package:new_fun_sphere/controller/task_controller.dart';
import 'package:new_fun_sphere/controller/user_controller.dart';
import 'package:new_fun_sphere/database/auth_service.dart';
import 'package:new_fun_sphere/database/user_service.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put<CheckinController>(CheckinController(), permanent: true);
    final TaskController taskController = Get.put<TaskController>(TaskController(), permanent: true);
    Get.putAsync<AuthController>(
        () async => AuthController(authService: AuthService()),
        permanent: true);
    Get.put<UserController>(UserController(userService: UserService()),
        permanent: true);
    await taskController.loadInitialData();
    await taskController.fetchPromotions();
  }
}
