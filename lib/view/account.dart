import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/auth_controller.dart';
import 'package:new_fun_sphere/controller/task_controller.dart';
import 'package:new_fun_sphere/controller/user_controller.dart';
import 'package:new_fun_sphere/database/auth_service.dart';
import 'package:new_fun_sphere/view/login_register.dart';
import 'package:new_fun_sphere/view/withdraw.dart';

class Account extends StatelessWidget {
  Account({super.key});

  final TaskController taskController = Get.put(TaskController());
  final UserController userController = Get.find<UserController>();
  final authController = Get.put(AuthController(authService: AuthService()));

  void _showLoginRegisterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LoginRegisterBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    taskController.fetchDoneTasks();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: double.infinity,
          height: 175,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset('assets/images/account_header_bg.png').image,
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30,
              ),
              Container(
                padding: const EdgeInsets.only(top: 60),
                child: CircleAvatar(
                    radius: 30,
                    child: ClipOval(
                        child: Image.asset(
                      "assets/images/avator.png",
                      width: 70, // 设置宽度
                      height: 70, // 设置高度
                      fit: BoxFit.contain, // 使用 contain 来缩小图像
                    ))),
              ),
              const SizedBox(
                width: 30,
              ),
              Container(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Username",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25.0,
                          color: Colors.white),
                    ),
                    Obx(
                      () {
                        return Text(
                          "ID: ${userController.user.email != null ? userController.user.name : 'anonymous'}",
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    )
                  ],
                ),
              ),
              // Column(
              //   children: [
                  // Container(
                  //     margin: const EdgeInsets.fromLTRB(10.0, 60.0, 0, 0),
                  //     decoration: const BoxDecoration(
                  //         image: DecorationImage(
                  //             image: AssetImage(
                  //                 'assets/images/signin_btn_bg.png'))),
                  //     child: TextButton(
                  //         onPressed: () {
                  //           _showLoginRegisterBottomSheet(context);
                  //         },
                  //         child: const Text(
                  //           'Sign in',
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.w900,
                  //               color: Color.fromRGBO(131, 147, 254, 1)),
                  //         ))),
                  // Container(
                  //     margin: const EdgeInsets.fromLTRB(30.0, 50.0, 0, 0),
                  //     decoration: const BoxDecoration(
                  //         image: DecorationImage(
                  //             image: AssetImage(
                  //                 'assets/images/signin_btn_bg.png'))),
                  //     child: TextButton(
                  //         onPressed: () {
                  //           authController.signOut();
                  //           Get.back();
                  //         },
                  //         child: const Text(
                  //           '临时',
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.w900,
                  //               color: Color.fromRGBO(131, 147, 254, 1)),
                  //         ))),
                // ],
              // )
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(30, 2, 30, 2),
            padding: const EdgeInsets.all(15),
            height: 190,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/images/card_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "your coins".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Anton",
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                  ),
                ),
                Obx(() {
                  return Text(
                    "${taskController.totalPoints}",
                    style: const TextStyle(fontSize: 45, color: Colors.white),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/coin.png",
                      width: 30,
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Game Coins",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Obx(() {
                          return Text('${taskController.totalPoints}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold));
                        }),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                      "assets/images/paypal.png",
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Cash Out Ready",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          return Text(
                            "\$${taskController.totalPoints / 1000}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        }),
                      ],
                    ),
                  ],
                )
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        Center(
            child: Container(
                width: 110,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/withdraw_btn_bg.png'))),
                child: TextButton(
                    onPressed: () {
                      var user = userController.user;
                      if (user != null && user.email != null) {
                        Get.to(Withdraw());
                      } else {
                        // Get.to(Withdraw());
                        _showLoginRegisterBottomSheet(context);
                      }
                    },
                    child: const Text(
                      "Withdrawal",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    )))),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30, top: 10),
            child: Text(
              "Tasks completed",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Anton",
                  letterSpacing: -1.0,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: taskController.doneTaskList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // 设置上下间距
                  child: CompletedTask(
                    source: taskController.doneTaskList[index].source,
                    apkUrl: taskController.doneTaskList[index].apkUrl,
                    iconUrl: taskController.doneTaskList[index].icon,
                    taskName: taskController.doneTaskList[index].name,
                    score: taskController.doneTaskList[index].score,
                    taskId: taskController.doneTaskList[index].id!,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class CompletedTask extends StatelessWidget {
  final String iconUrl;
  final String taskName;
  final int score;
  final int taskId;
  final String source;
  final String apkUrl;

  const CompletedTask(
      {super.key,
      required this.apkUrl,
      required this.source,
      required this.iconUrl,
      required this.taskName,
      required this.taskId,
      required this.score});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.put(TaskController());
    return Card(
      margin: const EdgeInsets.fromLTRB(18, 5, 18, 5),
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: source == "local"
                ? Image.asset(iconUrl, width: 60)
                : Image.file(File(iconUrl), width: 60),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 130,
            child: Text(
              taskName,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            ),
          ),
          Column(children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    "assets/images/coin.png",
                    width: 23,
                    height: 23,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      score.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 15),
                    ))
              ],
            ),
            Container(
                width: 100,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/done_btn_bg.png'))),
                child: TextButton(
                    onPressed: () {
                      // taskController.setTaskUnDone(taskId); // 临时打开
                      // taskController.fetchDoneTasks(); // 临时打开
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    )))
          ]),
        ],
      ),
    );
  }
}
