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
      // print(resData);
      final userDataFetch = UserModel(
        name: resData['name'],
        email: resData['email'],
        role: resData['role'],
        mpin: resData['mpin'],
        balance: resData['balance'],
        sapati: resData['sapati'],
        saving: resData['saving'],
        kyc: resData['kyc'],
      );
      _myDetail = userDataFetch;
      notifyListeners();
      // print('mero naam ${_myDetail!.name}');
    } catch (error) {
      throw error;
    }
  }
}
