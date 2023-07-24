import 'package:flutter/material.dart';
import '../Widgets/Shared/user_detail.dart';

class SendMoneyProcess extends StatelessWidget {
  static final routeName = "/sendmoney-process";
  const SendMoneyProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Send Money",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          icon: const Icon(
            Icons.navigate_before,
            color: Color.fromARGB(255, 70, 69, 69),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            const UserDetailSharedWidget(),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 100,
              color: Colors.black,
            ),
          ]),
        ),
      ),
    );
  }
}
