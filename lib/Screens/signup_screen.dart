import 'dart:ffi';

import 'package:flutter/material.dart';
import '../Widgets/stepper_widget.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = "/signup";
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Image(
            image: AssetImage("assets/images/icon2.png"),
            height: 70,
            width: 70,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(height: 360, child: SteppersWidget())
      ]),
    ));
  }
}
