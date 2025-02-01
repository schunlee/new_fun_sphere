import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
          .doc(authController.user!.uid)
          .snapshots()
          .listen((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          user = User.fromDocumentSnapshot(documentSnapshot: documentSnapshot);
          debugPrint('New User >>> ${user.accountBalance.toString()}');
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
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    User user = await userService.getUser(uid);
    // 点击withdraw按钮，赚取的积分就会记录在user.accountBalance，无论是否有PayPal withdraw行为
    if(user.lastWithdrawDate == formattedDate){
      Get.snackbar(
                "Attention",
                "You have already withdrawn today",
                snackPosition: SnackPosition.BOTTOM,
              );
      return user;
    }
    int newWithdrawBalance =
        ((user.accountBalance ?? 0)) + newEarnedScore - withdrawScore;
    try {
      await userService.addUserWithdrawRecord(
          newWithdrawBalance, withdrawScore, formattedDate, formattedTime, uid);
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
                "Error",
                "Withdraw Failed >>> ${e.toString()}",
                snackPosition: SnackPosition.BOTTOM,
              );
      return user;
    }
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
