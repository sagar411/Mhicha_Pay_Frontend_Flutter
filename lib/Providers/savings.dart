import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/config.dart';
import 'package:http/http.dart' as http;

class SavingsProvider extends ChangeNotifier {
  List<Saving> _savings = [];

  List<Saving> get savings {
    return [..._savings];
  }

  Future<void> postSaving(int amount, String purpose) async {
    print('tada');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse("http://${Config.authority}/saving");
    try {
      var responseData = await http.post(
        uri,
        body: jsonEncode(
          {
            "savingamount": amount,
            "purpose": purpose,
          },
        ),
        headers: headers,
      );

      var jsonData = jsonDecode(responseData.body);

      print(responseData.statusCode);
      if (responseData.statusCode != 200) {
        return Future.error(jsonData['error']['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getSaving() async {
    print('tada');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse("http://${Config.authority}/saving");
    try {
      var responseData = await http.get(
        uri,
        headers: headers,
      );

      var jsonData = jsonDecode(responseData.body);

      print(jsonData);
      if (responseData.statusCode == 200) {
        List<Saving> theSavings = [];
        for (var i in jsonData['savingsList']) {
          theSavings.add(Saving(
              id: i['_id'],
              userId: i['userId'],
              savingAmount: i['savingamount'],
              purpose: i['purpose'],
              paid: i['paid'],
              interestRate: i['interestRate']));
        }
        _savings = theSavings;
        notifyListeners();
      } else if (responseData.statusCode != 200) {
        return Future.error(jsonData['error']['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class Saving {
  final String id;
  final String userId;
  final int savingAmount;
  final String purpose;
  final bool paid;
  final int interestRate;

  Saving({
    required this.id,
    required this.userId,
    required this.savingAmount,
    required this.purpose,
    required this.paid,
    required this.interestRate,
  });
}
