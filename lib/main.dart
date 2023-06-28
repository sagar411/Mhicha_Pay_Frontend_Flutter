import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(223, 222, 31, 10),
            secondary: Color.fromARGB(192, 36, 14, 14)),
      ),
      routes: {
        LogInScreen.routeName: (ctx) => LogInScreen(),
      },
      home: SplashScreen(),
    );
  }
}
