import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/signup_screen.dart';
import 'Screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: GoogleFonts.roboto(),
        ),
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(223, 222, 31, 10),
            secondary: Color.fromARGB(192, 36, 14, 14)),
      ),
      routes: {
        LogInScreen.routeName: (ctx) => LogInScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen()
      },
      home: SplashScreen(),
    );
  }
}
