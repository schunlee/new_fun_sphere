import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Require',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          const Padding(
            padding: EdgeInsets.all(25.0),
            child: Text(
              'Withdrawals are limited to 1 time per day',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // 阴影颜色
                  spreadRadius: 2, // 阴影扩散半径
                  blurRadius: 5, // 模糊半径
                  offset: const Offset(0, 3), // 阴影偏移
                ),
              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
              margin: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
              child: const Row(
                children: [
                  Text(
                    'Minimum amount: ',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 15.0),
                  ),
                  Text(
                    '\$20',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                        color: Color.fromRGBO(5, 81, 181, 1)),
                  ),
                ],
              )),
          const SizedBox(
            height: 30.0,
          ),
          Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // 阴影颜色
                  spreadRadius: 2, // 阴影扩散半径
                  blurRadius: 5, // 模糊半径
                  offset: const Offset(0, 3), // 阴影偏移
                ),
              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
              margin: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
              child: const Row(
                children: [
                  Text('Withdrawal fee: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 15.0)),
                  Text('\$5+2%',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15.0,
                          color: Color.fromRGBO(5, 81, 181, 1))),
                ],
              )),
          const SizedBox(
            height: 30.0,
          ),
          Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // 阴影颜色
                  spreadRadius: 2, // 阴影扩散半径
                  blurRadius: 5, // 模糊半径
                  offset: const Offset(0, 3), // 阴影偏移
                ),
              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
              margin: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
              child: const Row(
                children: [
                  Text('Actual arrival: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                      )),
                  Text('\$14.6',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15.0,
                          color: Color.fromRGBO(5, 81, 181, 1))),
                ],
              )),
          const SizedBox(
            height: 10.0,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Under normal circumstances, it usually takes only a few seconds '
              'to convert coins to PayPal balance. You can change or cancel '
              'this authorization at any time from the "Account" tab. The amount '
              'will be automatically deducted after the withdrawal application is submitted. '
              'The manual review process may take 24 hours. Withdrawals are limited to 1 time per day. '
              'You can convert coins to PayPal balance and withdraw to your PayPal account.',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          )
        ],
      ),
    );
  }
}
