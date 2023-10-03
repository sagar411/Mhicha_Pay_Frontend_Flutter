import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Providers/sapati.dart';
import 'package:mhicha_pay_flutter/Providers/savings.dart';
import 'package:mhicha_pay_flutter/Providers/statements_provider.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:mhicha_pay_flutter/Screens/admin_dashboard.dart';
import 'package:mhicha_pay_flutter/Screens/confirm_otp_page.dart';
import 'package:mhicha_pay_flutter/Screens/dashboard_screen.dart';
import 'package:mhicha_pay_flutter/Screens/edit_profile_screen.dart';
import 'package:mhicha_pay_flutter/Screens/forgot_password_page.dart';
import 'package:mhicha_pay_flutter/Screens/qrscreen.dart';
import 'package:mhicha_pay_flutter/Screens/request_sapati.dart';
import 'package:mhicha_pay_flutter/Screens/save_money_page.dart';
import 'package:mhicha_pay_flutter/Screens/send_money_success_page.dart';
import 'Screens/splash_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/signup_screen.dart';
import 'Screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Screens/sendmoney.screen.dart';
import 'Screens/sendmoney_process.dart';
import 'Screens/statement_screen.dart';

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
        ),
        ChangeNotifierProvider(
          create: (ctx) => StatementsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SavingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SapatiProvider(),
        ),
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
          SendMoneyProcess.routeName: (ctx) => SendMoneyProcess(),
          StatementPage.routeName: (ctx) => StatementPage(),
          DashboardPage.routeName: (ctx) => DashboardPage(),
          QRPage.routeName: (ctx) => QRPage(),
          StatementPage.routeName: (ctx) => StatementPage(),
          SendMoneyProcess.routeName: (ctx) => SendMoneyProcess(),
          SendMoneySuccessPage.routeName: (ctx) => SendMoneySuccessPage(),
          SaveMoneyPage.routeName: (ctx) => SaveMoneyPage(),
          EditProfilePage.routeName: (ctx) => EditProfilePage(),
          RequestSapatiPage.routeName: (ctx) => RequestSapatiPage(),
          AdminDashboardPage.routeName: (ctx) => AdminDashboardPage(),
          SendMoneyScreen1.routeName: (ctx) => SendMoneyScreen1(),
          ForgotPasswordPage.routeName: (ctx) => ForgotPasswordPage(),
        },
        home: SplashScreen(),
      ),
    );
  }
}
