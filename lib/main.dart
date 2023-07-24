import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/signup_screen.dart';
import 'Screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Screens/sendmoney.screen.dart';
import 'Screens/sendmoney_process.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        )
      ],
      child: MaterialApp(
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
          MainScreen.routeName: (ctx) => MainScreen(),
          SendMoneyScreen.routeName: (ctx) => SendMoneyScreen(),
          SendMoneyProcess.routeName: (ctx) => SendMoneyProcess()
        },
        home: SplashScreen(),
      ),
    );
  }
}
