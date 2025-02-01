import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/auth_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:new_fun_sphere/view/withdraw.dart';

class LoginRegisterBottomSheet extends GetWidget<AuthController> {
// class LoginRegisterBottomSheet extends StatelessWidget {
  LoginRegisterBottomSheet({super.key});

  // 控制器只在这里创建一次
  final AuthController authController = Get.find<AuthController>();

  // 文本控制器
  final TextEditingController regNameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPwdController = TextEditingController();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPwdController = TextEditingController();

  final _currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        height: MediaQuery.of(context).size.height / 1.2,
        child: Column(children: [
          SizedBox(
            height: 80,
            child: Stack(
              textDirection: TextDirection.rtl,
              children: [
                Center(
                    child: ToggleSwitch(
                  minWidth: 90.0,
                  cornerRadius: 20.0,
                  activeBgColors: const [
                    [Colors.white],
                    [Colors.white]
                  ],
                  activeFgColor: const Color.fromRGBO(127, 176, 250, 1),
                  inactiveBgColor: const Color.fromRGBO(102, 139, 207, 1),
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: _currentIndex.value,
                  totalSwitches: 2,
                  labels: const ['Sign in', 'Register'],
                  radiusStyle: true,
                  onToggle: (index) {
                    _currentIndex.value = index!;
                  },
                )),
                IconButton(
                  icon: Image.asset(
                    "assets/images/close.png",
                    width: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Obx(() => _currentIndex.value == 0
              ? _buildSignInContent()
              : _buildRegisterContent())
        ]),
      ),
    );
  }

  Widget _buildSignInContent() {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 300,
          height: 60,
          child: TextFormField(
            controller: loginEmailController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              filled: true,
              labelStyle: const TextStyle(color: Colors.white),
              fillColor: Colors.black12,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 300,
          height: 45,
          child: TextFormField(
            autofocus: true,
            controller: loginPwdController,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              filled: true,
              labelStyle: const TextStyle(color: Colors.white),
              fillColor: Colors.black12,
            ),
            // obscureText: true,
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 40.0, height: 80),
            Checkbox(
                value: authController.isLoginChecked.value,
                side: const BorderSide(color: Colors.white),
                fillColor: MaterialStateProperty.resolveWith((states) {
                  return const Color.fromRGBO(127, 204, 224, 1);
                }),
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  authController.isLoginChecked.value = value ?? false;
                }),
            const Text("I Agree", style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            onPressed: () async {
              if (!authController.isLoginChecked.value) {
                Get.snackbar(
                  "Attention",
                  "Please agree to the terms of service",
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              bool isLogin = await authController.login(
                  loginEmailController.text, loginPwdController.text);
              if (Get.isSnackbarOpen) {
                debugPrint("close");
                if (isLogin) {
                  Get.close(0);
                }
              } else {
                debugPrint("isLogin: $isLogin");
                if (isLogin) {
                  Get.back();
                }
              }
              if (isLogin) {
                Get.to(Withdraw());
              }
            },
            child: const Text(
              'Sign In',
              style: TextStyle(color: Color.fromRGBO(135, 176, 254, 1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterContent() {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 300,
          height: 80,
          child: TextField(
            autofocus: true,
            controller: regNameController,
            decoration: InputDecoration(
              hintText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              filled: true,
              labelStyle: const TextStyle(color: Colors.white),
              fillColor: Colors.black12,
            ),
          ),
        ),
        SizedBox(
          width: 300,
          height: 45,
          child: TextField(
            autofocus: true,
            controller: regEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              filled: true,
              labelStyle: const TextStyle(color: Colors.white),
              fillColor: Colors.black12,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 300,
          height: 45,
          child: TextField(
            controller: regPwdController,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              filled: true,
              labelStyle: const TextStyle(color: Colors.white),
              fillColor: Colors.black12,
            ),
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 40, height: 80),
            Checkbox(
                value: authController.isRegChecked.value,
                side: const BorderSide(color: Colors.white),
                fillColor: MaterialStateProperty.resolveWith((states) {
                  return const Color.fromRGBO(127, 204, 224, 1);
                }),
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  authController.isRegChecked.value = value ?? false;
                }),
            const Text("I Agree", style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            onPressed: () async {
              if (!authController.isRegChecked.value) {
                Get.snackbar(
                  "Attention",
                  "Please agree to the terms of service",
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              bool isReg = await authController.createUser(
                  regNameController.text,
                  regEmailController.text,
                  regPwdController.text);
              if (Get.isSnackbarOpen) {
                debugPrint("close");
                if (isReg) {
                  Get.close(0);
                }
              } else {
                debugPrint("isReg: $isReg");
                if (isReg) {
                  Get.back();
                }
              }
              if (isReg) {
                Get.to(Withdraw()); // 登录成功才跳转到Withdraw页面
              }
            },
            child: const Text(
              'Register',
              style: TextStyle(color: Color.fromRGBO(135, 176, 254, 1)),
            ),
          ),
        ),
      ],
    );
  }
}
