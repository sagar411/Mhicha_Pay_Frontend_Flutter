import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/receiver.dart';
import 'package:mhicha_pay_flutter/Providers/send.dart';
import 'package:mhicha_pay_flutter/Screens/main_screen.dart';
import '../Widgets/Shared/user_detail.dart';
import '../Screens/statement_screen.dart';

class SendMoneyProcess extends StatelessWidget {
  static final routeName = "/sendmoney-process";
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _mpinController = TextEditingController();
  Map<String, String> _authData = {
    "mpin": "",
  };
  SendMoneyProcess({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      print(_mpinController.text);
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      _formKey.currentState!.save();
      try {
        await SendMoneyProvider.sendMoney(
          ReceiverData.ReceiverEmail,
          int.parse(ReceiverData.Transferamount),
          ReceiverData.Transferremarks,
          ReceiverData.TransferPurpose,
          _mpinController.text,
        ).then((value) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              StatementPage.routeName, (route) => route.isFirst);
        });
      } catch (error) {
        Navigator.of(context).pop();
        await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
        print(error.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Send Money",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          icon: const Icon(
            Icons.navigate_before,
            color: Color.fromARGB(255, 70, 69, 69),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              const UserDetailSharedWidget(),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary.withOpacity(0.8)
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(20),
                  // padding: EdgeInsets.all(30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Receiver Name",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(ReceiverData.ReceiverName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(ReceiverData.ReceiverEmail,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(ReceiverData.Transferamount,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Remarks",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(ReceiverData.Transferremarks,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Purpose",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(ReceiverData.TransferPurpose,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Form(
                          key: _formKey,
                          child: SizedBox(
                            height: double.infinity,
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Icon(
                                    Icons.pin,
                                    size: 10,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Enter Mpin to send money!",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "should not be empty!";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['mpin'] = value as String;
                                    },
                                    controller: _mpinController,
                                    decoration: InputDecoration(
                                      labelText: "Mpin",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(175, 60),
                                            backgroundColor: Colors.grey),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancle"),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(175, 60),
                                        ),
                                        onPressed: _submit,
                                        child: const Text("Send"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 60),
                  ), // Set the minimum size
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(16),
                  ),
                ),
                child: const Text("Send "),
              )
            ],
          ),
        ),
      ),
    );
  }
}
