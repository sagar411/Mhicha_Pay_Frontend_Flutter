import "dart:io";

import "package:flutter/material.dart";
import "package:mhicha_pay_flutter/Models/receiver.dart";
import "package:mhicha_pay_flutter/Providers/user.provider.dart";
import '../Screens/sendmoney_process.dart';

class SendMoneyFormWidget extends StatefulWidget {
  const SendMoneyFormWidget({super.key});

  @override
  State<SendMoneyFormWidget> createState() => _SendMoneyFormWidgetState();
}

class _SendMoneyFormWidgetState extends State<SendMoneyFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _sendMoneyData = {
    "email": "",
    "amount": "",
    "remarks": "",
    "purpose": ""
  };
  Future<void> fetchReciverUser(String email) async {
    try {
      await UserProvider.fetchUserByEmail(email).then((value) {
        ReceiverData.ReceiverEmail = _emailController.text;
        ReceiverData.Transferamount = _amountController.text;
        ReceiverData.Transferremarks = _remarksController.text;
        Navigator.of(context).pushNamed(SendMoneyProcess.routeName);
      });
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Internet Connection")));
    } catch (error) {
      print("error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error.toString(),
          style: TextStyle(color: Colors.red),
        ),
      ));
    }
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    await fetchReciverUser(_emailController.text);
    _formKey.currentState!.save();
  }

  String purpose = '';
  List<String> purposes = [
    'Personal Use',
    'Borrow / Lend',
    'Family Expenses',
    'Bill Sharing',
    'Salary',
    'Others'
  ];
  final _emailController = TextEditingController();
  final _remarksController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return "Invalid email !";
              }
              return null;
            },
            onSaved: (value) {
              _sendMoneyData['email'] = value as String;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Amount",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (int.tryParse(value!) == null) {
                return 'Enter valid value';
              }
              if (value.isEmpty) {
                return 'Please specify the amount';
              }

              return null;
            },
            keyboardType: TextInputType.number,
            controller: _amountController,
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              isDense: true,
              label: const Text("Purpose"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            items: purposes.map(
              (purpose) {
                return DropdownMenuItem(
                  child: Text(purpose),
                  value: purpose,
                );
              },
            ).toList(),
            onChanged: (value) {
              purpose = value as String;
            },
            validator: (value) {
              if (value == null) {
                return "Please select a purpose";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Remarks",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
            keyboardType: TextInputType.text,
            controller: _remarksController,
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Provide your remarks!";
              }
              return null;
            },
            autofocus: false,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _submit,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                const Size(double.infinity, 60),
              ), // Set the minimum size
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(16),
              ),
            ),
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
