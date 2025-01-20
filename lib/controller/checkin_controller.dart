import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_fun_sphere/database/database_fetch.dart';
import 'package:new_fun_sphere/model/task.dart';

class CheckinController extends GetxController {
  var recordList = <Checkin>[].obs;

  Future<bool> addRecord(int score) async {
    // 添加签到记录
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    bool result =
        await CheckinDbHelper.instance.queryByDate(formattedDate).then((value) {
      // Checkin record = Checkin(checkinDate: formattedDate, score: score);
      // CheckinDbHelper.instance.insert(record.toMap());
      if (value.isEmpty) {
        Checkin record = Checkin(checkinDate: formattedDate, score: score);
        CheckinDbHelper.instance.insert(record.toMap());
        fetchRecords();
        return true;
      } else {
        return false;
      }
    });

    return result;
  }

  void fetchRecords() async {
    // 获取所有签到记录
    var records = await CheckinDbHelper.instance.queryAllRecords();
    recordList.clear();
    recordList.addAll(records.map((e) => Checkin.fromMap(e)));
  }

  void deleteRecord() async {
    // 删除签到记录
    await CheckinDbHelper.instance.deleteAll();
    recordList.clear();
    fetchRecords();
  }
}
