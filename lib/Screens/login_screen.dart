import 'package:flutter/material.dart';
import '../Widgets/login_form_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInScreen extends StatelessWidget {
  static const routeName = "/login-screen";
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            children: const <Widget>[
              Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/images/icon1.png"),
                  width: 170,
                  height: 170,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Welcome to MhichaPay!",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Login to Continue!",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        color: Colors.grey)),
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
