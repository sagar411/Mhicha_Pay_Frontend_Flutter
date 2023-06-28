import 'package:flutter/material.dart';
import '../Widgets/login_form_widget.dart';

class LogInScreen extends StatelessWidget {
  static const routeName = "/login-screen";
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: const <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/images/icon1.png"),
                  width: 200,
                  height: 200,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Welcome to MhichaPay!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Login to Continue!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              LoginFormWidget()
            ],
          ),
        ),
      ),
    );
  }
}
