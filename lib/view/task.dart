import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/checkin_controller.dart';
import 'package:new_fun_sphere/controller/task_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Task extends StatelessWidget {
  Task({super.key});

  final TaskController taskController = Get.put(TaskController());
  final CheckinController checkController = Get.put(CheckinController());

  @override
  Widget build(BuildContext context) {
    taskController.fetchTasks();
    checkController.fetchRecords();

    var checkinRecords = List<Widget>.generate(7, (index) {
      debugPrint(index.toString());
      int point = 100;
      if (index < 3) {
        point = 100;
      } else if (index < 5) {
        point = 150;
      } else {
        point = 200;
      }

      return Obx(() {
        return Row(
          children: [
            index + 1 <= checkController.recordList.length
                ? CheckinCircle(
                    day: index + 1,
                    isChecked: true,
                    point: point,
                  )
                : CheckinCircle(
                    day: index + 1,
                    isChecked: false,
                    point: point,
                  ),
            if (index < 6)
              Transform.translate(
                  offset: const Offset(0, -10),
                  child: SizedBox(
                      height: 2.0,
                      child: Image.asset("assets/images/divider.png",
                          width: 8.0, fit: BoxFit.cover)))
          ],
        );
      });
    });

    return Container(
      color: const Color.fromRGBO(238, 244, 245, 1),
      child: Column(
          mainAxisSize: MainAxisSize.max, // 使 Column 自适应高度
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              height: 275,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/account_header_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 120), // 适当的上边距
                  child: const Text("Task Center",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Anton",
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      )),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -140),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 5.0,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Game Coins',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            return Text(
                              '${taskController.totalPoints}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0),
                            );
                          }),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Image.asset(
                            "assets/images/coin.png",
                            width: 23,
                            height: 23,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 70,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/checkin_btn_bg.png'))),
                    child: Obx(() {
                      return TextButton(
                          onPressed: checkController.recordList.length >= 7
                              ? null
                              : () async {
                                  int addPoint = 100;
                                  if (checkController.recordList.length < 3) {
                                    addPoint = 100;
                                  } else if (checkController.recordList.length <
                                      5) {
                                    addPoint = 150;
                                  } else {
                                    addPoint = 200;
                                  }
                                  bool addFlag =
                                      await checkController.addRecord(addPoint);
                                  if (!addFlag) {
                                    Get.snackbar(
                                      "Attention",
                                      "You have already checked in today",
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                          child: const Text(
                            "Check in",
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(130, 150, 254, 1)),
                          ));
                    }),
                  ),
                  // Container(
                  //     width: 50,
                  //     decoration: const BoxDecoration(
                  //         image: DecorationImage(
                  //             image: AssetImage(
                  //                 'assets/images/checkin_btn_bg.png'))),
                  //     child: TextButton(
                  //         onPressed: () {
                  //           checkController.deleteRecord();
                  //         },
                  //         child: const Text(
                  //           "临时",
                  //           style: TextStyle(
                  //               fontSize: 10.0,
                  //               fontWeight: FontWeight.bold,
                  //               color: Color.fromRGBO(130, 150, 254, 1)),
                  //         ))),
                  const SizedBox(
                    width: 5.0,
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -120),
              child: Container(
                // padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
                // margin: const EdgeInsets.all(25),
                width: 320,
                height: 150,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(157, 168, 246, 1), // 边框颜色
                    width: 2, // 边框宽度
                  ),
                  color: const Color.fromRGBO(255, 255, 255, 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Replace with a valid value for the mainAxisAlignment property
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Row(
                            children: [
                              const Text(
                                'Check in for',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    letterSpacing: -1.0),
                              ),
                              Obx(() {
                                return Text(
                                  ' ${checkController.recordList.length} ',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(255, 124, 42, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      letterSpacing: -1.0),
                                );
                              }),
                              const Text(
                                'day in a row',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    letterSpacing: -1.0),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Obx(() {
                              return Text(
                                  ' +${checkController.recordList.map((record) => record.score).isNotEmpty ? checkController.recordList.map((record) => record.score).reduce((a, b) => a + b) : 0} coins',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(255, 124, 42, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ));
                            })),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: checkinRecords,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Sign-in bonus gold coins',
                            style: TextStyle(
                                fontSize: 10.0,
                                letterSpacing: -1.0,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(178, 178, 178, 1)),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -60),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // 阴影颜色
                        spreadRadius: 2, // 阴影扩散半径
                        blurRadius: 5, // 模糊半径
                        offset: const Offset(0, 3), // 阴影偏移
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
                    children: [
                      // 添加标题
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Text(
                          'Receive tasks', // 标题文本
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.0),
                        ),
                      ),
                      // 使用 Obx 监听任务列表
                      Expanded(
                        child: Obx(() {
                          return ListView.builder(
                            itemCount: taskController.taskList.length,
                            itemBuilder: (context, index) {
                              return TaskCard(
                                source: taskController.taskList[index].source,
                                apkUrl: taskController.taskList[index].apkUrl,
                                icon: taskController.taskList[index].icon,
                                taskName: taskController.taskList[index].name,
                                score: taskController.taskList[index].score,
                                taskId: taskController.taskList[index].id!,
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}

class CheckinCircle extends StatelessWidget {
  final int day;
  final bool isChecked;
  final int point;

  const CheckinCircle(
      {super.key,
      required this.day,
      required this.isChecked,
      required this.point});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isChecked
                    ? const AssetImage('assets/images/checkin.png')
                    : const AssetImage('assets/images/uncheckin.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center, // 使内容居中
            child: Center(
                child: Text(
              '$point',
              style: const TextStyle(
                  fontWeight: FontWeight.w900, color: Colors.white),
            ))),
        Text(
          "Day $day",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              color: isChecked
                  ? const Color.fromRGBO(255, 124, 42, 1)
                  : const Color.fromRGBO(178, 178, 178, 1)),
        )
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final String source;
  final String apkUrl;
  final String icon;
  final String taskName;
  final int score;
  final int taskId;

  const TaskCard(
      {super.key,
      required this.apkUrl,
      required this.source,
      required this.icon,
      required this.taskName,
      required this.taskId,
      required this.score});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.put(TaskController());
    return Card(
      elevation: 0.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          source == "local"
              ? Image.asset(
                  icon,
                  height: 60.0,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(icon),
                  height: 60.0,
                  fit: BoxFit.cover,
                ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 130,
                child: Text(taskName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 13)),
              ),
            ],
          ),
          Center(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  taskController.setTaskDone(taskId);
                  taskController.fetchTasks();
                  final Uri url = Uri.parse(apkUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Could not launch $url",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                },
                child: Chip(
                  backgroundColor: const Color.fromRGBO(255, 124, 42, 1),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromRGBO(255, 124, 42, 1), // 边框颜色
                      width: 0.0, // 边框宽度
                    ),
                    borderRadius: BorderRadius.circular(8), // 圆角
                  ),
                  label: Text(score.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.white)),
                  avatar: Image.asset(
                    "assets/images/coin.png",
                    width: 23,
                    height: 23,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
