import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/config.dart';

class Sapati with ChangeNotifier {
  final String id;
  final String userId;
  final String userName;
  final double amount;
  final String purpose;
  bool approvedByAdmin;
  bool paid;

  Sapati({
    required this.id,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.purpose,
    required this.approvedByAdmin,
    required this.paid,
  });

  Future<void> payBackSapati(String id, String purpose) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse("http://${Config.authority}/sapati/returnsapati/$id");
    try {
      var responseData = await http.post(
        uri,
        body: jsonEncode(
          {
            "purpose": purpose,
          },
        ),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);
      print(jsonData);
      print(responseData.statusCode);
      if (responseData.statusCode == 200) {
        paid = !paid;
        notifyListeners();
      }
      if (responseData.statusCode != 200) {
        return Future.error(jsonData['error']['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> approveSapatiRequest(String id, String purpose) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse("http://${Config.authority}/sapati/approve/$id");
    try {
      var responseData = await http.post(
        uri,
        // body: jsonEncode(
        //   {
        //     "purpose": purpose,
        //   },
        // ),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);
      print(jsonData);
      if (responseData.statusCode == 200) {
        approvedByAdmin = !approvedByAdmin;
        notifyListeners();
      }
      if (responseData.statusCode != 200) {
        return Future.error(jsonData['error']['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class SapatiProvider with ChangeNotifier {
  List<Sapati> _sapatis = [];

  List<Sapati> get sapatis {
    return [..._sapatis];
  }

  Future<void> requestSapati(int amount, String purpose) async {
    print('tada');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse("http://${Config.authority}/sapati/request");
    try {
      var responseData = await http.post(
        uri,
        body: jsonEncode(
          {
            "sapatiAmount": amount,
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

  Future<void> getSapatiList() async {
    print('tada');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse("http://${Config.authority}/sapati/sapatilistuser");
    try {
      var responseData = await http.get(
        uri,
        headers: headers,
      );

      print(responseData.statusCode);

      var jsonData = jsonDecode(responseData.body);

      print(jsonData);
      if (responseData.statusCode == 200) {
        List<Sapati> theSapatis = [];
        for (var i in jsonData) {
          theSapatis.add(
            Sapati(
              id: i['_id'],
              userId: i['userId'],
              userName: i['userName'],
              amount: double.parse(
                i['sapatiAmount'].toString(),
              ),
              purpose: i['purpose'],
              approvedByAdmin: i['approvedByAdmin'],
              paid: i['paid'],
            ),
          );
        }
        _sapatis = theSapatis;
        notifyListeners();
      } else if (responseData.statusCode != 200) {
        return Future.error(jsonData['error']['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getSapatiRequest() async {
    print('tada');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse("http://${Config.authority}/sapati/getlist");
    try {
      var responseData = await http.get(
        uri,
        headers: headers,
      );

      print(responseData.statusCode);

      var jsonData = jsonDecode(responseData.body);

      print(jsonData);
      if (responseData.statusCode == 200) {
        List<Sapati> theSapatis = [];
        for (var i in jsonData) {
          theSapatis.add(
            Sapati(
              id: i['_id'],
              userId: i['userId'],
              userName: i['userName'],
              amount: double.parse(
                i['sapatiAmount'].toString(),
              ),
              purpose: i['purpose'],
              approvedByAdmin: i['approvedByAdmin'],
              paid: i['paid'],
            ),
          );
        }
        _sapatis = theSapatis;
        notifyListeners();
      } else if (responseData.statusCode != 200) {
        return Future.error(jsonData['error']['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
