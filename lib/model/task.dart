class Task {
  int? id; // 任务ID
  String name; // 任务名
  int score; // 积分
  String icon; // App图标
  int isCompleted; // 状态，默认为未完成
  int isPromotion; // 是否为推广任务
  String source; // 来源, local or remote
  String apkUrl; // apk下载地址
  int rank; // 排序

  Task(
      {this.id,
      required this.rank,
      required this.name,
      required this.score,
      required this.icon,
      required this.apkUrl,
      required this.isPromotion,
      required this.source,
      this.isCompleted = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'icon': icon,
      'isCompleted': isCompleted,
      'isPromotion': isPromotion,
      'source': source,
      'apkUrl': apkUrl,
      'rank': rank
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      score: map['score'],
      isCompleted: map['isCompleted'],
      icon: map['icon'],
      isPromotion: map['isPromotion'],
      source: map['source'],
      apkUrl: map['apkUrl'],
      rank: map['rank'],
    );
  }
}

class Checkin {
  String checkinDate; // 签到日期
  int score; // 积分

  Checkin({required this.checkinDate, required this.score});

  Map<String, dynamic> toMap() {
    return {'checkinDate': checkinDate, 'score': score};
  }

  factory Checkin.fromMap(Map<String, dynamic> map) {
    return Checkin(checkinDate: map['checkinDate'], score: map['score']);
  }
}
