import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:new_fun_sphere/model/user.dart';

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
        "score": user.score,
        "withdrawCount": user.withdrawCount,
        "historyScore": user.historyScore,
        "lastWithdrawDate": user.lastWithdrawDate
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
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<bool> updateScore(int newValue, String uid) async {
    try {
      _firestore.collection("users").doc(uid).update({"score": newValue});
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateUserInfo(int newHisScore, int newScore, int withdrawCount,
      String formattedDate, String uid) async {
    try {
      _firestore.collection("users").doc(uid).update({
        "historyScore": newHisScore,
        "lastWithdrawDate": formattedDate,
        "score": newScore,
        "withdrawCount": withdrawCount
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
