import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mhicha_pay_flutter/Providers/auth.dart';
import './login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then(
      (value) {
        AuthService.autoLogin(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
              image: AssetImage("assets/images/icon1.png"),
              width: 250,
            ),
            SizedBox(
              height: 50,
            ),
            SpinKitSquareCircle(
              color: Color.fromARGB(223, 222, 31, 10),
              size: 50.0,

              // ThreeInOut()
            )
          ],
        ),
      ),
    );
  }
}
