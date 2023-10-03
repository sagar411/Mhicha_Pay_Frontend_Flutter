import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mhicha_pay_flutter/Models/receiver.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/Models/user.model.dart';
import 'package:mhicha_pay_flutter/config.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  UserModel? _myDetail;

  // Map<String, UserModel> _myDetail = {};
  UserModel get myDetail {
    return _myDetail!;
  }

  Future<void> toggleTwoFactor() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${SharedData.token}"
    };

    Uri uri = Uri.parse("http://${Config.authority}/user/update-twofactor");

    try {
      var response = await http.put(
        uri,
        headers: headers,
      );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _myDetail!.twofactor = !_myDetail!.twofactor;
        notifyListeners();
      } else {
        // print(Future.error(resData['error']['message']));
        return Future.error('Something went wrong.');
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<void> fetchUserByEmail(String email) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${SharedData.token}"
    };

    Uri uri = Uri.parse("http://${Config.authority}/user/receiver/${email}");

    try {
      var response = await http.get(
        uri,
        headers: headers,
      );
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
      throw error;
    }

    return Future(() => {});
  }

  Future<void> userData() async {
    print(SharedData.token);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${SharedData.token}"
    };

    Uri uri =
        Uri.parse("http://${Config.authority}/user/me/${SharedData.userId}");
    try {
      var response = await http.get(
        uri,
        headers: headers,
      );
      final resData = json.decode(response.body);
      print(resData);
      // print(resData);
      final userDataFetch = UserModel(
        name: resData['name'],
        email: resData['email'],
        role: resData['role'],
        mpin: resData['mpin'],
        balance: resData['balance'],
        sapati: resData['sapati'],
        saving: resData['saving'],
        twofactor: resData['twofactor'],
      );
      _myDetail = userDataFetch;
      notifyListeners();
      SharedData.email = userDataFetch.email;
      SharedData.name = userDataFetch.name;
      SharedData.twofactor = userDataFetch.twofactor;
      // print('mero naam ${_myDetail!.name}');
    } catch (error) {
      print('send otp error');
      throw error;
    }
  }

  Future<void> updateUserData(String name, String email) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };
    try {
      Uri uri = Uri.parse("http://${Config.authority}/user/update-profile");
      var response = await http.put(
        uri,
        headers: headers,
        body: json.encode(
          {
            "name": name,
          },
        ),
      );

      print(response.statusCode);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
