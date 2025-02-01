import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:new_fun_sphere/model/user.dart';
import 'package:stack_trace/stack_trace.dart';

class UserService {
  static UserService? _instance;
  UserService._();
  factory UserService() => _instance ??= UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(User user) async {
    // Forestore创建User
    try {
      await _firestore.collection("users").doc(user.userId).set({
        "name": user.name,
        "email": user.email,
        'withdraw_records': [],
        "account_balance": 0,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<User> getUser(String uid) async {
    // 获取用户信息
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();

      return User.fromDocumentSnapshot(documentSnapshot: doc);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      final chain = Chain.forTrace(stackTrace);
      debugPrint('Formatted stack trace:\n$chain');
      rethrow;
    }
  }

  Future<void> addUserWithdrawRecord(int withdrawBalance, int withdrawScore,
      String formattedDate, String uid) async {
      // 获取用户文档
      DocumentReference userDoc = _firestore.collection("users").doc(uid);

      // 开始一个事务来安全地更新记录
      await _firestore.runTransaction((transaction) async {
        // 获取用户文档快照
        DocumentSnapshot userSnapshot = await transaction.get(userDoc);

        if (!userSnapshot.exists) {
          return;
        }

        // 获取当前的 withdrawRecords
        List<dynamic> currentWithdrawRecords =
            userSnapshot.get('withdraw_records') ?? [];

        // 添加新的提现记录
        currentWithdrawRecords.add({
          "withdrawTime": formattedDate,
          "withdrawScore": withdrawScore,
          "withdrawBalance": withdrawBalance,
        });

        // 更新用户文档
        transaction.update(userDoc, {
          'withdraw_records': currentWithdrawRecords,
          'account_balance': withdrawBalance,
        });
      });
  }

  Future<bool> updateUserWithdrawBalance(
      int withdrawBalance, String uid) async {
    try {
      // 获取用户文档
      DocumentReference userDoc = _firestore.collection("users").doc(uid);

      // 开始一个事务来安全地更新记录
      await _firestore.runTransaction((transaction) async {
        // 获取用户文档快照
        DocumentSnapshot userSnapshot = await transaction.get(userDoc);

        if (!userSnapshot.exists) {
          // 如果用户文档不存在，返回 false
          return false;
        }

        // 更新用户文档
        transaction.update(userDoc, {
          'account_balance': withdrawBalance,
        });
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
