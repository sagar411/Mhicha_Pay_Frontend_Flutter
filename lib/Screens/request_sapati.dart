import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/Providers/sapati.dart';
import 'package:mhicha_pay_flutter/Providers/savings.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:provider/provider.dart';

class RequestSapatiPage extends StatefulWidget {
  static String routeName = '/requestsapatipage';
  const RequestSapatiPage({super.key});

  @override
  State<RequestSapatiPage> createState() => _SaveMoneyPageState();
}

class _SaveMoneyPageState extends State<RequestSapatiPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController purposeContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Sapati'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: amountController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Invalid Amount";
                  }
                  if (int.parse(value!) <= 50) {
                    return "Invalid Amount";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Purpose",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: purposeContoller,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return "purpose is too short !";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 60)), // Set the minimum size
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(16),
                  ), // Set the padding
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  Provider.of<SapatiProvider>(
                    context,
                    listen: false,
                  )
                      .requestSapati(
                    int.parse(amountController.text),
                    purposeContoller.text,
                  )
                      .then((value) {
                    Provider.of<UserProvider>(context, listen: false)
                        .userData();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Request made successfully.')));
                    Navigator.of(context).pop();
                  }).catchError((e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  });
                },
                child: const Text(
                  "Request Sapati",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
