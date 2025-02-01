import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/user_controller.dart';
import 'package:new_fun_sphere/database/auth_service.dart';
import 'package:new_fun_sphere/model/user.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({required this.authService});

  final Rx<fauth.User?> _firebaseUser =
      Rx<fauth.User?>(fauth.FirebaseAuth.instance.currentUser);
  var isRegChecked = false.obs;
  var isLoginChecked = false.obs;

  fauth.User? get user => _firebaseUser.value;

  @override
  onInit() {
    _firebaseUser.bindStream(authService.authStateChanges());
    super.onInit();
  }

  void clear() {
    _firebaseUser.value = null;
  }

  Future<bool> createUser(String name, String email, String password) async {
    // 注册用户
    try {
      fauth.UserCredential authResult =
          await authService.createUser(name, email, password);

      if (authResult.user == null) {
        debugPrint('authResult.user == null');
        return false;
      }

      _firebaseUser.value = authResult.user;

      User user = User(
        userId: authResult.user!.uid,
        name: name,
        email: authResult.user!.email,
      );
      final userController = Get.find<UserController>();
      if (await userController.createNewUser(user)) {
        userController.user = user;
        Get.snackbar(
          "Success",
          "User registered and logged in: ${user.email}",
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        debugPrint('user was not created.');
        return false;
      }
    } catch (e) {
      if (e.toString().contains("email-already-in-use")) {
        Get.snackbar(
          "The account already exists for that email.",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error creating Account",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      e.printError();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      fauth.UserCredential authResult =
          await authService.login(email, password);
      final userController = Get.find<UserController>();

      _firebaseUser.value = authResult.user;
      

      Get.snackbar(
        "Success",
        "User logged in: $email",
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint("User logged in: $email");
      
      User user = await userController.getUser(authResult.user!.uid);
      userController.user = user;
      
      return true;
    } catch (e) {
      Get.snackbar(
        "Error signing in",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      e.printError();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await authService.signOut();
      _firebaseUser.value = null;
      Get.snackbar(
        "Success",
        "User logged out",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      e.printError();
    }
  }
}
