import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mhicha_pay_flutter/Models/receiver.dart';
import 'package:mhicha_pay_flutter/Providers/statements_provider.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:mhicha_pay_flutter/Screens/dashboard_screen.dart';
import 'package:mhicha_pay_flutter/Screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import 'dart:convert';
import '../Models/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  //final Submission
  static Future<void> finalSubmit(
      String name, String email, String password, String mpin) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      Uri uri = Uri.parse("http://${Config.authority}/user/signup");
      var response = await http.post(
        uri,
        headers: headers,
        body: json.encode(
          {
            "name": name,
            "email": email,
            "password": password,
            "mpin": mpin,
          },
        ),
      );
      var resData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedData.token = resData['token'];
        SharedData.userId = resData['user']['_id'];
        SharedData.email = resData['user']['email'];
        SharedData.twofactor = resData['user']['twofactor'];
        SharedData.name = resData['user']['name'];
        SharedData.role = resData['user']['role'];
        SharedData.balance = resData['user']['balance'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', resData['token']);
        await prefs.setString('userId', resData['user']['_id']);
        await prefs.setBool('twofactor', resData['user']['twofactor']);
        await prefs.setString('role', resData['user']['role']);
      } else {
        throw Future.error(resData['error']['message']);
      }
    } on SocketException {
      return Future.error('No internet connection');
    } catch (error) {
      throw error;
    }
  }

  //SENDING OTP
  static Future<int> sendOTP(String email) async {
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Uri uri = Uri.parse("http://${Config.authority}/user/verify_email");
      var response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          "email": email,
        }),
      );

      var responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedData.email = responseData['email'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', responseData['email']);
        return response.statusCode;
      } else {
        throw (responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<int> updatePassword(String email, String password) async {
    print(email);
    print(password);
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Uri uri =
          Uri.parse("http://${Config.authority}/user/update-password/$email");
      var response = await http.put(
        uri,
        headers: headers,
        body: json.encode({
          'password': password,
        }),
      );

      var responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.statusCode;
      } else {
        throw (responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<int> sendOTP1(String email) async {
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Uri uri =
          Uri.parse("http://${Config.authority}/user/update-password-request");
      var response = await http.post(
        uri,
        headers: headers,
        body: json.encode({
          "email": email,
        }),
      );

      var responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.statusCode;
      } else {
        throw (responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<bool> checkOtpValidation(String email, String otp) async {
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Uri uri = Uri.parse("http://${Config.authority}/user/findOtp");
      var response = await http.post(
        uri,
        headers: headers,
        body: json.encode(
          {
            "email": email,
            "otp": otp,
          },
        ),
      );
      print(response.body);
      var jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonData['status'];
      } else {
        throw (jsonData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<bool> checkOtpValidation1(String email, String otp) async {
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
      Uri uri = Uri.parse(
          "http://${Config.authority}/user/update-password-otp-validate");
      var response = await http.post(
        uri,
        headers: headers,
        body: json.encode(
          {
            "email": email,
            "otp": otp,
          },
        ),
      );
      print(response.body);
      var jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonData['status'];
      } else {
        throw (jsonData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<void> authenticate(String email, String password) async {
    // print("Hello from auth!");

    Map<String, String> headers = {
      "Content-type": "application/json",
    };
    try {
      // );
      Uri uri = Uri.parse("http://${Config.authority}/user/login");
      Map<String, String> header = {"Content-Type": "application/json"};
      var response = await http.post(
        uri,
        body: json.encode(
          {
            "email": email,
            "password": password,
          },
        ),
        headers: header,
      );

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedData.token = jsonData['token'];
        SharedData.userId = jsonData['user']['_id'];
        SharedData.email = jsonData['user']['email'];
        SharedData.twofactor = jsonData['user']['twofactor'];
        SharedData.name = jsonData['user']['name'];
        SharedData.role = jsonData['user']['role'];
        SharedData.balance = jsonData['user']['balance'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonData['token']);
        await prefs.setString('userId', jsonData['user']['_id']);
        await prefs.setBool('twofactor', jsonData['user']['twofactor']);
        await prefs.setString('role', jsonData['user']['role']);
      } else {
        return Future.error(jsonData['error']['message']);
      }
    } on SocketException {
      return Future.error('No internet connection');
    } catch (err) {
      //  var jsonData = jsonDecode(err);
      print('sign in ma');
      throw err;
    }
  }
}

class AuthService {
  static Future<void> autoLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      print('no');
      Navigator.pushReplacementNamed(context, LogInScreen.routeName);
    } else {
      print('yes');
      SharedData.token = prefs.getString('token').toString();
      SharedData.userId = prefs.getString('userId').toString();
      print(SharedData.userId);
      try {
        print('first');
        await Provider.of<UserProvider>(context, listen: false)
            .userData()
            .then((_) async {
          print('here');
          await Provider.of<StatementsProvider>(context, listen: false)
              .getStatements('All')
              .then((_) {
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          });
        });
      } on SocketException {
        print('internet');
        Navigator.pushReplacementNamed(context, LogInScreen.routeName);
      } catch (e) {
        print('error');
        print(e.toString());
        Navigator.pushReplacementNamed(context, LogInScreen.routeName);
      }
    }
  }

  static Future<void> fetchUserByEmail(String email) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${SharedData.token}"
    };

    Uri uri = Uri.parse("http://${Config.authority}/user/receiver/$email");

    try {
      var response = await http.get(
        uri,
        headers: headers,
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      final resData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ReceiverData.ReceiverId = resData['_id'];
        ReceiverData.ReceiverEmail = resData['email'];
        ReceiverData.ReceiverName = resData['name'];
      } else {
        // print(Future.error(resData['error']['message']));
        return Future.error(resData['error']['message']);
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  static Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, LogInScreen.routeName, (route) => false);
  }
}
