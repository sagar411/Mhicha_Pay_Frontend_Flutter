import 'package:flutter/material.dart';
import '../Widgets/Shared/user_detail.dart';
import '../Widgets/send_money_widget.dart';

class SendMoneyScreen extends StatelessWidget {
  static const routeName = "/sendmoney";
  const SendMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          alignment: Alignment.topLeft,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: Color.fromARGB(255, 70, 69, 69),
          ),
        ),
        title: const Text(
          "Send Money",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: const <Widget>[
            const SizedBox(
              height: 10,
            ),
            UserDetailSharedWidget(),
            const SizedBox(
              height: 20,
            ),
            SendMoneyFormWidget()
          ]),
        ),
      ),
    );
  }
}

class SendMoneyScreen1 extends StatelessWidget {
  static const routeName = "/sendmoney1";
  const SendMoneyScreen1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final email = routeArgs['email'] as String;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          alignment: Alignment.topLeft,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.navigate_before,
            color: Color.fromARGB(255, 70, 69, 69),
          ),
        ),
        title: const Text(
          "Send Money",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            UserDetailSharedWidget(),
            const SizedBox(
              height: 20,
            ),
            SendMoneyFormWidget1(
              email: email,
            )
          ]),
        ),
      ),
    );
  }
}
