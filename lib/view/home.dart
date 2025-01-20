import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/navigation_controller.dart';
import 'package:new_fun_sphere/controller/task_controller.dart';
import 'package:new_fun_sphere/controller/utils.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final GlobalKey gkey;
  const Home({super.key, required this.gkey});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TaskController taskController = Get.put(TaskController());

  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
    taskController.fetchPromotions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(238, 244, 245, 1),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Welcome Back!",
            style: TextStyle(
              fontFamily: "Anton",
              fontSize: 40.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Obx(
            () {
              if (taskController.appList.isEmpty) {
                taskController.fetchPromotions();
                return const Text('');
              }
              return taskController
                          .appList[taskController.currentIndex.value].source ==
                      'local'
                  ? Image.asset(
                      taskController
                          .appList[taskController.currentIndex.value].icon,
                      width: 280.0,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(taskController
                          .appList[taskController.currentIndex.value].icon),
                      width: 280.0,
                      fit: BoxFit.cover,
                    );
            },
          ),
          const SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Container(
                        height: 50,
                        child: Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          taskController.appList.isNotEmpty
                              ? taskController
                                  .appList[taskController.currentIndex.value]
                                  .name
                              : '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: -1.5),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (taskController.appList.isEmpty) {
                        taskController.fetchPromotions();
                      }
                      return Text(
                        "SCORE: ${taskController.appList.isNotEmpty ? taskController.appList[taskController.currentIndex.value].score : ''}",
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1),
                      );
                    }),
                  ],
                ),
              ),
              Showcase(
                key: widget.gkey,
                description: 'Click here to play',
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/play_btn_bg.png"),
                        fit: BoxFit.cover,
                      )),
                  child: TextButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(taskController
                          .appList[taskController.currentIndex.value].apkUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Could not launch $url",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                      // installAPK(
                      //     "https://s3.cn-north-1.amazonaws.com.cn/mtab.kezaihui.com/apk/kylinim/zaihui_kylinim_42.apk",
                      //     "zaihui_kylinim_42.apk");
                    },
                    child: Text(
                      "play".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: SizedBox(
              width: 300,
              height: 58,
              child: Obx(() {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskController.appList.length,
                    itemExtent: 100,
                    itemBuilder: (context, index) {
                      final item = taskController.appList[index];
                      return ListTile(
                        // tileColor: Colors.blue,
                        leading: SizedBox(
                          // width: 301,
                          height: 100,
                          child: item.source == "local"
                              ? Image.asset(item.icon, fit: BoxFit.cover)
                              : Image.file(File(item.icon), fit: BoxFit.cover),
                        ),
                        onTap: () => {
                          if (navigationController.isLock.value == true)
                            {}
                          else
                            {
                              debugPrint(
                                  'Tapped on: ${item.name}, Score: ${item.score}, index: ${index}'),
                              taskController.currentIndex(index)
                              // print('Tapped on: ${sample.name ?? sample.title}, Score: ${sample.score}')
                            }
                        },
                      );
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }
}
