import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/controller/auth_controller.dart';
import 'package:new_fun_sphere/controller/task_controller.dart';
import 'package:new_fun_sphere/controller/user_controller.dart';
import 'package:new_fun_sphere/database/auth_service.dart';
import 'package:new_fun_sphere/database/user_service.dart';
import 'package:new_fun_sphere/view/intro.dart';

class Withdraw extends StatelessWidget {
  Withdraw({super.key});
  final TaskController taskController = Get.put(TaskController());
  final UserController userController =
      Get.put(UserController(userService: UserService()));
  final authController =
      Get.put<AuthController>(AuthController(authService: AuthService()));

  final TextEditingController accountController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('PayPal Account',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900)),
      ),
      body: Column(
        children: [
          Container(
            height: 220,
            width: 350,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/paypal_bg.png').image,
                // fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 130.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                  child: Obx(() {
                    return Text(
                      '\$${userController.user.accountBalance! / 1000}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w900),
                    );
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                  child: Text(
                    'Avaiable PayPal Balance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        letterSpacing: -1.0,
                        fontWeight: FontWeight.w900),
                  ),
                )
              ],
            ),
          ),
          // const SizedBox(height: 5.0),
          Container(
            margin: const EdgeInsets.fromLTRB(35, 0, 35, 0),
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/exchange_bg.png').image,
                fit: BoxFit.contain,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Game Coins',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0),
                    ),
                    Obx(() {
                      return Text('${taskController.totalPoints}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900));
                    }),
                  ],
                ),
                Image.asset(
                  'assets/images/switch.png',
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Withdrawable (\$)',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0),
                    ),
                    Obx(() {
                      return Text('\$${taskController.totalPoints / 1000}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900));
                    }),
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(178, 178, 178, 1),
              borderRadius: BorderRadius.circular(20), // 设置圆角
            ),
            child: TextButton.icon(
              onPressed: () {
                Get.to(() => const Intro());
              },
              label: const Text(
                'Intro',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.0),
              ),
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
          ),
          // const SizedBox(height: 5.0),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // 阴影颜色
                  spreadRadius: 2, // 阴影扩散半径
                  blurRadius: 5, // 模糊半径
                  offset: const Offset(0, 3), // 阴影偏移
                ),
              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: [
                      const Center(
                        child: Text("Account Withdrawable:",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                fontSize: 15.0,
                                color: Color.fromRGBO(0, 41, 145, 1))),
                      ),
                      Obx(() {
                        return Center(
                          child: Text(
                            '\$${((taskController.totalPoints + userController.user.accountBalance!) / 1000).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                fontSize: 15.0,
                                color: Color.fromRGBO(0, 41, 145, 1)),
                          ),
                        );
                      }),
                    ],
                  ),
                  // ),
                  // const SizedBox(
                  //   height: 5.0,
                  // ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Color.fromRGBO(0, 41, 145, 1),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                          child: Text('Amount:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.0,
                                  letterSpacing: -1.0)),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 180,
                            height: 40,
                            child: TextField(
                              controller: amountController
                                ..text = '${taskController.totalPoints / 1000}',
                              keyboardType: TextInputType.number,
                              // enabled: false,
                              decoration: const InputDecoration(
                                hintText: 'Amount',
                                border: InputBorder.none,
                                filled: true,
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.black12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.card_membership,
                            color: Color.fromRGBO(0, 41, 145, 1)),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                          child: Text('Account:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.0,
                                  letterSpacing: -1.0)),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 180,
                            height: 40,
                            child: TextField(
                              controller: accountController
                                ..text = '${userController.user.email}',
                              keyboardType: TextInputType.emailAddress,
                              enabled: false,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                border: InputBorder.none,
                                filled: true,
                                labelStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.black12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/withdraw_btn_bg.png'))),
                          child: TextButton(
                              onPressed: () {
                                double money =
                                    double.parse(amountController.text);
                                if (money >
                                    double.parse(((taskController.totalPoints +
                                                userController
                                                    .user.accountBalance!) /
                                            1000)
                                        .toStringAsFixed(2))) {
                                  Get.snackbar(
                                    "Notice",
                                    "Cannot withdraw money above total points",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                                // else if (money < 20.0) {
                                //   Get.snackbar(
                                //     "Notice",
                                //     "Please read info above, the minimum withdraw amount is \$20",
                                //     snackPosition: SnackPosition.BOTTOM,
                                //   );
                                // }
                                else {
                                  userController.addRecord(
                                      taskController.totalPoints,
                                      (money * 1000).toInt(),
                                      authController.user!.uid);
                                }
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ))))
                ],
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
