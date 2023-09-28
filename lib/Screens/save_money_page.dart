import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Providers/savings.dart';
import 'package:provider/provider.dart';

class SaveMoneyPage extends StatefulWidget {
  static String routeName = '/savemoneypage';
  const SaveMoneyPage({super.key});

  @override
  State<SaveMoneyPage> createState() => _SaveMoneyPageState();
}

class _SaveMoneyPageState extends State<SaveMoneyPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController purposeContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: amountController,
              validator: (value) {
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
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: purposeContoller,
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return "purpose is too short !";
                }
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
                Provider.of<SavingsProvider>(
                  context,
                  listen: false,
                )
                    .postSaving(
                  int.parse(amountController.text),
                  purposeContoller.text,
                )
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saving made successfully.')));
                  Navigator.of(context).pop();
                }).catchError((e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                });
              },
              child: const Text(
                "Save Money",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
