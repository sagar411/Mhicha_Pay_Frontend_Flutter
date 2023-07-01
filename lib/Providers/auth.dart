import 'dart:io';

import 'package:http/http.dart' as http;
import '../config.dart';
import 'dart:convert';
import '../Models/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<void> authenticate(String email, String password) async {
    // print("Hello from auth!");

    Map<String, String> headers = {
      "Content-type": "application/json",
    };
    try {
      print('yeta');
      // Uri url = Uri.http(Config.authority, "user/login");

      // final response = await http.post(
      //   Uri.parse('http://10.2.0.6:3000/user/login'),
      //   headers: headers,
      //   body: json.encode(
      //     {
      //       "email": email,
      //       "password": password,
      //     },
      //   ),
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
        return Future.error('Invalid email or password!');
      }
    } on SocketException {
      return Future.error('No internet connection');
    } catch (err) {
      return Future.error(err.toString());
    }
  }
}
