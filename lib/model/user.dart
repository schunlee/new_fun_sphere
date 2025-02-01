import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawRecord {
  String withdrawTime; // 提现时间
  int withdrawScore; // 提现金额
  int withdrawBalance; // 提现余额

  WithdrawRecord(
      {required this.withdrawTime,
      required this.withdrawScore,
      required this.withdrawBalance});

  // 从 Firestore 文档中创建 WithdrawRecord
  WithdrawRecord.fromDocument(Map<String, dynamic> data)
      : withdrawTime = data['withdrawTime'] ?? '',
        withdrawScore = data['withdrawScore'] ?? '',
        withdrawBalance = data['withdrawBalance'] ?? '';
}

class User {
  String? userId; // 用户 ID
  String? name; // 用户名
  String? email; // PayPal 账户
  int? accountBalance; // 提现余额
  String? lastWithdrawDate; // 上次提现日期
  List<WithdrawRecord> withdrawRecords; // 提现记录

  User({
    this.userId,
    this.name,
    this.email,
    this.accountBalance,
    this.lastWithdrawDate,
    List<WithdrawRecord>? withdrawRecords,
  }) : withdrawRecords = withdrawRecords ?? [];

  User.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot})
      : userId = documentSnapshot.id,
        name = documentSnapshot.get("name"),
        email = documentSnapshot.get("email"),
        accountBalance = documentSnapshot.get("account_balance"),
        lastWithdrawDate = documentSnapshot.get("last_withdraw_date"),
        withdrawRecords =
            (documentSnapshot.get("withdraw_records") as List<dynamic>?)
                    ?.map((record) => WithdrawRecord.fromDocument(record))
                    .toList() ??
                [];

  // 可选：方法将用户对象转换为 Map 以便存入 Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'account_balance': accountBalance,
      'last_withdraw_date': lastWithdrawDate,
      'withdraw_records': withdrawRecords
          .map((record) => {
                'withdrawTime': record.withdrawTime,
                'withdrawScore': record.withdrawScore,
                'withdrawBalance': record.withdrawBalance,
              })
          .toList(),
    };
  }
}
