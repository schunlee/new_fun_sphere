import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? userId;
  String? name;
  String? email; // PayPal account
  int? withdrawCount; // 提现次数
  int? score; // 获得的积分，可清空
  String? lastWithdrawDate; // 上次提现日期
  int? historyScore; // 历史获得的积分，不可清空

  User(
      {this.userId,
      this.name,
      this.email,
      this.lastWithdrawDate = '',
      this.withdrawCount = 0,
      this.score = 0,
      this.historyScore = 0});

  User.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    userId = documentSnapshot.id;
    name = documentSnapshot.get("name");
    email = documentSnapshot["email"];
    score = documentSnapshot.get("score");
    withdrawCount = documentSnapshot.get("withdrawCount");
    lastWithdrawDate = documentSnapshot.get("lastWithdrawDate");
    historyScore = documentSnapshot.get("historyScore");
  }
}
