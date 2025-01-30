import 'package:cloud_firestore/cloud_firestore.dart';
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
      // getUser(authController.user!.uid).then((value) => user = value);
      FirebaseFirestore.instance
          .collection('users')
          .doc(authController.user!.uid) // 替换为实际用户ID
          .snapshots()
          .listen((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          user = User.fromDocumentSnapshot(
              documentSnapshot: documentSnapshot); // 更新用户数据
        }
      });
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

  Future<User> addRecord(
      int newEarnedScore, int withdrawScore, String uid) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    User user = await userService.getUser(uid);
    // 点击withdraw按钮，赚取的积分就会记录在user.accountBalance，无论是否有PayPal withdraw行为
    int newWithdrawBalance =
        ((user.accountBalance ?? 0)) + newEarnedScore - withdrawScore;
    var test = await userService.addUserWithdrawRecord(
        newWithdrawBalance, withdrawScore, formattedDate, uid);

    user.accountBalance = newWithdrawBalance;
    user.withdrawRecords.add(WithdrawRecord(
      withdrawBalance: withdrawScore,
      withdrawScore: withdrawScore,
      withdrawTime: formattedDate,
    ));

    taskController.setAllTasksUnDone();
    checkController.deleteRecord(); // 不再重新签到
    taskController.totalScore.value = 0;
    checkController.recordList.clear();
    taskController.doneTaskList.clear();
    Get.back();
    return user;
  }
}
