import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_fun_sphere/controller/auth_controller.dart';
import 'package:new_fun_sphere/controller/checkin_controller.dart';
import 'package:new_fun_sphere/controller/task_controller.dart';
import 'package:new_fun_sphere/database/auth_service.dart';
import 'package:new_fun_sphere/database/user_service.dart';
import 'package:new_fun_sphere/model/user.dart';

class UserController extends GetxController {
  final UserService userService;
  final CheckinController checkController = Get.put(CheckinController());
  final TaskController taskController = Get.put(TaskController());
  

  UserController({required this.userService});

  final Rx<User> _user = User().obs;

  User get user => _user.value;

  set user(User value) => _user.value = value;

  @override
  void onInit() {
    final authController = Get.put(AuthController(authService: AuthService()));
    if (authController.user != null) {
      getUser(authController.user!.uid).then((value) => user = value);
    }
    super.onInit();
  }

  void clear() {
    _user.value = User();
  }

  Future<bool> createNewUser(User user) async {
    _user.value = user;
    return await userService.createNewUser(user);
  }

  Future<User> getUser(String uid) async {
    // 获取用户信息
    return await userService.getUser(uid);
  }

  Future<User> addRecord(int newStore, String uid) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    User user = await userService.getUser(uid);
    int newHisScore = user.historyScore! + newStore;
    int newScore = newStore;
    int newWithdrawCount = user.withdrawCount! + 1;
    userService.updateScore(newStore, uid);
    await userService.updateUserInfo(
        newHisScore, newStore, newWithdrawCount, formattedDate, uid);

    user.score = newScore;
    user.historyScore = newHisScore;
    user.lastWithdrawDate = formattedDate;
    user.withdrawCount = newWithdrawCount;

    taskController.setAllTasksUnDone();
    checkController.deleteRecord();
    Get.back();
    return user;
  }
}
