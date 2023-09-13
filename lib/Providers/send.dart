import 'dart:async';
import 'dart:convert';

import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/config.dart';
import 'package:http/http.dart' as http;

class SendMoneyProvider {
  static Future<void> sendMoney(String email, int amount, String remarks,
      String purpose, String mpin) async {
    print("here!!");
    Uri uri = Uri.parse("http://${Config.authority}/balance/sendmoney");
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${SharedData.token}"
    };
    final resData;

    try {
      var response = await http.post(
        uri,
        headers: headers,
        body: json.encode(
          {
            "email": email,
            "amount": amount,
            "remarks": remarks,
            "purpose": purpose,
            "mpin": mpin
          },
        ),
      );

      resData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        print(resData['error']['message']);
        throw Exception(resData['error']['message'].toString());
      }
    } catch (error) {
      throw error;
    }
  }
}
