import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/utils.dart';
import 'package:new_fun_sphere/database/database_fetch.dart';
import 'package:new_fun_sphere/model/task.dart';
// import 'package:http/http.dart' as http;
import 'package:new_fun_sphere/controller/checkin_controller.dart';

class TaskController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // @override
  // void onInit() {
  //   loadInitialData();
  //   fetchPromotions();
  //   super.onInit();
  // }

  List<Map<String, dynamic>> localTasks = [
    {
      'name': 'DBZ: Super Goku Battle',
      'rank': 90,
      'score': 350,
      'icon': 'assets/images/game_1.png',
      'source': 'local',
      'isPromotion': 1,
      'apkUrl':
          'https://cdn.pixelshippuden.com/pixelshippuden_f_release_1008201500.apk',
    },
    {
      'name': 'Stick Shinobi Fighting',
      'rank': 91,
      'score': 250,
      'icon': 'assets/images/game_2.png',
      'source': 'local',
      'isPromotion': 0,
      'apkUrl':
          'https://cdn.pixelshippuden.com/pixelshippuden_f_release_1008201500.apk',
    },
    {
      'name': '3D Tile Match',
      'rank': 92,
      'score': 100,
      'icon': 'assets/images/game_3.png',
      'source': 'local',
      'isPromotion': 0,
      'apkUrl':
          'https://cdn.pixelshippuden.com/pixelshippuden_f_release_1008201500.apk',
    },
    {
      'name': 'Supreme Duelist',
      'rank': 93,
      'score': 100,
      'icon': 'assets/images/game_4.png',
      'source': 'local',
      'isPromotion': 0,
      'apkUrl':
          'https://cdn.pixelshippuden.com/pixelshippuden_f_release_1008201500.apk',
    }
  ];

  var taskList = <Task>[].obs;
  var appList = <Task>[].obs;
  var doneTaskList = <Task>[].obs;
  var totalScore = 0.obs;

  final CheckinController checkController =
      Get.find(); // 获取 CheckinController 实例

  int get totalPoints {
    return totalScore.value +
        (checkController.recordList.map((record) => record.score).isNotEmpty
            ? checkController.recordList
                .map((record) => record.score)
                .reduce((a, b) => a + b)
            : 0);
  }

  Future<void> loadInitialData() async {
    TaskDbHelper.instance.deleteAll();
    // 将本地任务插入数据库
    for (var task in localTasks) {
      bool isExist = await TaskDbHelper.instance
          .checkTaskExists(task['name'], task['isPromotion']);
      if (!isExist) {
        await TaskDbHelper.instance.insert(task);
      }
    }
    try {
      // 下载远程任务config.json文件，并下载相应图片，将远程任务插入数据库
      var configUrl =
          "https://pub-fcdda0d64de44d99988d15c3e7d66a68.r2.dev/config.json";
      var configFile = await downloadFile(configUrl, 'config.json');
      var configContent = await configFile.readAsString();
      var jsonData = jsonDecode(configContent);
      try {
        var jsonData = jsonDecode(configContent);
      } catch (e) {
        debugPrint('Error decoding JSON: $e');
      }
      var targetVersion = jsonData['target_version'];
      debugPrint('Target version: $targetVersion');

      List<dynamic> filteredTasks = jsonData['tasks']
          .where((task) => task['version'] == targetVersion)
          .toList();
      // 下载图片，并将Url改为本地路径，插入数据库
      for (var task in filteredTasks) {
        var iconUrl = task['icon'];
        var filename = getFileName(iconUrl);
        var iconFile = await downloadFile(iconUrl, filename);
        task['icon'] = iconFile.path;
        task.remove('version');
        bool isExist = await TaskDbHelper.instance
            .checkTaskExists(task['name'], task['isPromotion']);
        if (!isExist) {
          await TaskDbHelper.instance.insert(task);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchTasks() async {
    // 从数据库中获取未完成任务，能够获取任务完成状态
    var tasks = await TaskDbHelper.instance.queryAllUnDoneTasks();
    taskList.clear();
    taskList.addAll(tasks.map((e) => Task.fromMap(e)));
  }

  Future<void> fetchPromotions() async {
    // 从数据库中获取所有推广
    var tasks = await TaskDbHelper.instance.queryAllPromotions();
    debugPrint(tasks.toString());
    appList.clear();
    appList.addAll(tasks.map((e) => Task.fromMap(e)));
  }

  void fetchDoneTasks() async {
    // 从数据库中获取已完成任务
    var tasks = await TaskDbHelper.instance.queryAllDoneTasks();
    doneTaskList.clear();
    doneTaskList.addAll(tasks.map((e) => Task.fromMap(e)));
    var test = doneTaskList.map((e) => e.score).toList();
    totalScore.value = test.isNotEmpty ? test.reduce((a, b) => a + b) : 0;
  }

  void setTaskDone(int taskId) async {
    // 将任务标记为已完成
    await TaskDbHelper.instance.updateTaskStatus(taskId);
    fetchDoneTasks();
  }

  // 把所有任务设为未完成
  void setAllTasksUnDone() async {
    var tasks = await TaskDbHelper.instance.queryAllDoneTasks();
    for (var task in tasks) {
      var taskObject = Task.fromMap(task);
      await TaskDbHelper.instance
          .updateTaskStatus(taskObject.id!, isCompleted: 0);
    }
  }

  void setTaskUnDone(int taskId) async {
    // 将任务标记为未完成
    await TaskDbHelper.instance.updateTaskStatus(taskId, isCompleted: 0);
    fetchDoneTasks();
  }

  void deleteAllTasks() async {
    // 删除所有任务
    await TaskDbHelper.instance.deleteAll();
    taskList.clear();
    doneTaskList.clear();
    totalScore.value = 0;
  }
}
