// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';

// import 'package:http/http.dart' as http;
// import 'package:mhicha_pay_flutter/Models/shared_data.dart';

// import '../Models/balance.model.dart';
// import '../config.dart';

// class StatementsProvider with ChangeNotifier {
//   List<FundTransferModel> _statements = [];

//   List<FundTransferModel> get statements {
//     return [..._statements];
//   }

//   List<FundTransferModel> _recentStatements = [];

//   List<FundTransferModel> get recentStatements {
//     return [..._recentStatements];
//   }

//   Future<void> getStatements() async {
//     Map<String, String> headers = {
//       "Content-type": "application/json",
//       "Authorization": "Bearer ${SharedData.token}",
//     };

//     Uri uri = Uri.parse(
//         "http://${Config.authority}/tranasctions/list/${SharedData.userId}");
//     try {
//       var responseData = await http.get(
//         uri,
//         headers: headers,
//       );
//       print(responseData.statusCode);
//       if (responseData.statusCode == 204) {
//         _statements = [];
//         notifyListeners();
//         _recentStatements = [];
//         notifyListeners();
//         return;
//       }

//       var jsonData = jsonDecode(responseData.body);
//       List<FundTransferModel> _loadedStatements = [];

//       if (responseData.statusCode == 401) {
//         return Future.error('Something went wrong.');
//       }
//       for (var transaction in jsonData) {
//         if (transaction['cashFlow'] == 'Out') {
//           _loadedStatements.add(
//             FundTransferModel(
//               transactionCode: transaction['transactionId'],
//               receiverMhichaEmail: transaction['receiverEmail'],
//               receiverUserName: transaction['receiverName'],
//               senderMhichaEmail: SharedData.email,
//               senderUserName: SharedData.name,
//               amount: double.parse(transaction['amount'].toString()),
//               purpose: transaction['purpose'],
//               remarks: transaction['remarks'],
//               time: transaction['createdAt'],
//               cashFlow: transaction['cashFlow'],
//             ),
//           );
//         } else if (transaction['cashFlow'] == 'In') {
//           _loadedStatements.add(
//             FundTransferModel(
//               transactionCode: transaction['transactionId'],
//               receiverMhichaEmail: SharedData.email,
//               receiverUserName: SharedData.name,
//               senderMhichaEmail: transaction['senderEmail'] ?? '',
//               senderUserName: transaction['senderName'] ?? '',
//               amount: double.parse(transaction['amount'].toString()),
//               purpose: transaction['purpose'],
//               remarks: transaction['remarks'],
//               time: transaction['createdAt'],
//               cashFlow: transaction['cashFlow'],
//             ),
//           );
//         }
//       }
//       _statements = _loadedStatements.reversed.toList();
//       notifyListeners();
//       _recentStatements = _statements.take(3).toList();
//       notifyListeners();
//     } on SocketException {
//       return Future.error('No Internet connection');
//     } catch (e) {
//       return Future.error(
//         e.toString(),
//       );
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mhicha_pay_flutter/Models/shared_data.dart';

import '../Models/balance.model.dart';
import '../config.dart';

class StatementsProvider with ChangeNotifier {
  List<FundTransferModel> _statements = [];

  List<FundTransferModel> get statements {
    return [..._statements];
  }

  List<FundTransferModel> _recentStatements = [];

  List<FundTransferModel> get recentStatements {
    return [..._recentStatements];
  }

  Future<void> getStatements(String filterBy) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedData.token}",
    };

    Uri uri = Uri.parse(
        "http://${Config.authority}/tranasctions/list/${SharedData.userId}");
    try {
      var responseData = await http.get(
        uri,
        headers: headers,
      );
      if (responseData.statusCode == 204) {
        _statements = [];
        notifyListeners();
        _recentStatements = [];
        notifyListeners();
        return;
      }

      var jsonData = jsonDecode(responseData.body);
      List<FundTransferModel> _loadedStatements = [];

      if (jsonData['status']) {
        _statements = [];
        notifyListeners();
        return;
      } else if (responseData.statusCode == 401) {
        return Future.error('Something went wrong.');
      }
      for (var transaction in jsonData) {
        if (transaction['cashFlow'] == 'Out') {
          _loadedStatements.add(
            FundTransferModel(
              transactionCode: transaction['transactionId'],
              receiverMhichaEmail: transaction['receiverEmail'],
              receiverUserName: transaction['receiverName'],
              senderMhichaEmail: SharedData.email,
              senderUserName: SharedData.name,
              amount: double.parse(transaction['amount'].toString()),
              purpose: transaction['purpose'],
              remarks: transaction['remarks'],
              time: transaction['createdAt'],
              cashFlow: transaction['cashFlow'],
            ),
          );
        } else if (transaction['cashFlow'] == 'In') {
          _loadedStatements.add(
            FundTransferModel(
              transactionCode: transaction['transactionId'],
              receiverMhichaEmail: SharedData.email,
              receiverUserName: SharedData.name,
              senderMhichaEmail: transaction['senderEmail'] ?? '',
              senderUserName: transaction['senderName'] ?? '',
              amount: double.parse(transaction['amount'].toString()),
              purpose: transaction['purpose'],
              remarks: transaction['remarks'],
              time: transaction['createdAt'],
              cashFlow: transaction['cashFlow'],
            ),
          );
        }
      }
      if (filterBy == 'All') {
        _statements = _loadedStatements.reversed.toList();
        notifyListeners();
      } else if (filterBy == 'Debit') {
        _statements = _loadedStatements.reversed
            .where((statement) => statement.cashFlow == 'In')
            .toList();
        notifyListeners();
      } else if (filterBy == 'Credit') {
        _statements = _loadedStatements.reversed
            .where((statement) => statement.cashFlow == 'Out')
            .toList();
        notifyListeners();
      }

      _recentStatements = _loadedStatements.reversed.take(3).toList();
      notifyListeners();
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      return Future.error(
        e.toString(),
      );
    }
  }
}
