import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    Future.delayed(Duration(seconds: 4)).then((value) {
      // Navigator.of(context).pushReplacement(newRoute)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/icon1.png"),
              width: 250,
            ),
            SizedBox(
              height: 50,
            ),
            SpinKitSquareCircle(
              color: Colors.orange,
              size: 50.0,

              // ThreeInOut()
            )
          ],
        ),
      ),
    );
  }
}
