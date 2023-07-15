import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
