import 'dart:io';

import 'package:http/http.dart' as http;
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
        SharedData.kyc = resData['user']['kyc'];
        SharedData.name = resData['user']['name'];
        SharedData.role = resData['user']['role'];
        SharedData.balance = resData['user']['balance'];
        

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', resData['token']);
        await prefs.setString('userId', resData['user']['_id']);
        await prefs.setBool('kyc', resData['user']['kyc']);
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

  // static Future<void> signUp(String email, String password, ){

  // }
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
        SharedData.kyc = jsonData['user']['kyc'];
        SharedData.name = jsonData['user']['name'];
        SharedData.role = jsonData['user']['role'];
        SharedData.balance = jsonData['user']['balance'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonData['token']);
        await prefs.setString('userId', jsonData['user']['_id']);
        await prefs.setBool('kyc', jsonData['user']['kyc']);
        await prefs.setString('role', jsonData['user']['role']);
      } else {
        return Future.error(jsonData['error']['message']);
      }
    } on SocketException {
      return Future.error('No internet connection');
    } catch (err) {
      //  var jsonData = jsonDecode(err);
      throw err;
    }
  }
}
