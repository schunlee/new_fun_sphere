import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDbHelper {
  static const _databaseName = "user.db";
  static const _databaseVersion = 1;

  static const table = "user";

  UserDbHelper._privateConstructor();
  static final CheckinDbHelper instance = CheckinDbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            password TEXT NOT NULL
          );
          ''');
  }
}

class CheckinDbHelper {
  static const _databaseName = "checkin.db";
  static const _databaseVersion = 1;

  static const table = "checkin";

  CheckinDbHelper._privateConstructor();
  static final CheckinDbHelper instance = CheckinDbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            score INTEGER NOT NULL,
            checkinDate TEXT NOT NULL,
            withdrawFlag BOOL NOT NULL
          );
          ''');
  }

  Future<int> insert(Map<String, dynamic> map) async {
    // 插入签到记录
    Database db = await instance.database;
    var res = await db.insert(table, map,
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return res;
  }

  Future<List<Map<String, dynamic>>> queryByDate(String dateStr) async {
    // 根据日期获取签到记录
    Database db = await instance.database;
    var res = await db.query(table,
        where: "checkinDate = ?", whereArgs: [dateStr], orderBy: "id DESC");
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRecords() async {
    // 获取所有签到记录
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "id DESC");
    return res;
  }

  Future<int> deleteAll() async {
    // 删除签到记录
    Database db = await instance.database;
    var res = await db.delete(table);
    return res;
  }

  Future<int> updateCheckinStatus(int id, {bool withdrawFlag = true}) async {
    // 完成任务后更新状态
    Database db = await instance.database;
    var res = await db.update(table, {'withdrawFlag': withdrawFlag},
        where: "id = ?", whereArgs: [id]);
    return res;
  }
}

class TaskDbHelper {
  static const _databaseName = "task.db";
  static const _databaseVersion = 1;

  static const table = "task";

  TaskDbHelper._privateConstructor();
  static final TaskDbHelper instance = TaskDbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            score INTEGER NOT NULL,
            icon TEXT NOT NULL,
            rank INTEGER NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            isPromotion INTEGER NOT NULL DEFAULT 0,
            source TEXT NOT NULL,
            apkUrl TEXT NOT NULL
            
          );
          ''');
  }

  Future<int> insert(Map<String, dynamic> task) async {
    // 插入初始值
    Database db = await instance.database;
    var res = await db.insert(table, task,
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    // 获取所有任务
    try {
      Database db = await instance.database;
    } catch (e) {
      var test = '';
      debugPrint(e.toString());
    }

    Database db = await instance.database;
    var res = await db.query(table,
        where: "isPromotion = ?", whereArgs: [0], orderBy: "rank");
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllPromotions() async {
    // 获取所有推广
    Database db = await instance.database;
    var res = await db.query(table,
        where: "isPromotion = ?", whereArgs: [1], orderBy: "rank");
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllDoneTasks() async {
    // 获取所有已完成任务
    Database db = await instance.database;
    var res = await db.query(table,
        where: "isCompleted = ? AND isPromotion = ?",
        whereArgs: [1, 0],
        orderBy: "rank");
    return res;
  }

  Future<bool> checkTaskExists(String taskName, int isPromotion) async {
    // 允许同名任务在普通任务列表，推广任务列表中同时存在
    Database db = await instance.database;
    var res = await db.query(table,
        where: "name = ? AND isPromotion = ?",
        whereArgs: [taskName, isPromotion],
        orderBy: "rank");
    if (res.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllUnDoneTasks() async {
    // 获取所有未完成任务
    Database db = await instance.database;
    var res = await db.query(table,
        where: "isCompleted = ? AND isPromotion = ?",
        whereArgs: [0, 0],
        orderBy: "rank");
    return res;
  }

  Future<int> queryTotalScoreOfDoneTasks() async {
    // 获取所有已完成任务的score总和
    Database db = await instance.database;
    var res = await db.rawQuery(
        'SELECT SUM(score) as totalScore FROM $table WHERE isCompleted = ?',
        [1]);

    // 返回总分数，注意可能会返回 null
    return res.isNotEmpty && res.first['totalScore'] != null
        ? res.first['totalScore'] as int
        : 0;
  }

  Future<int> updateTaskStatus(int id, {int isCompleted = 1}) async {
    // 完成任务后更新状态
    Database db = await instance.database;
    var res = await db.update(table, {'isCompleted': isCompleted},
        where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    // 删除所有任务
    Database db = await instance.database;
    var res = await db.delete(table);
    return res;
  }

  //delete by id
  Future<int> deleteTask(int id) async {
    Database db = await instance.database;
    var res = await db.delete(table, where: "id = ?", whereArgs: [id]);
    return res;
  }
}
