import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignupFormSubmit extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController mpinController;
  final GlobalKey formKey;
  SignupFormSubmit(
      {required this.nameController,
      required this.passwordController,
      required this.mpinController,
      required this.formKey});

  @override
  State<SignupFormSubmit> createState() => SignupFormSubmitState();
}

class SignupFormSubmitState extends State<SignupFormSubmit> {
  Map<String, String> _authData = {
    "name": "",
    "password": "",
    "mpin": "",
  };

  bool _pwvisible = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              controller: widget.nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your name";
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value as String;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _pwvisible = !_pwvisible;
                    });
                  },
                  child: Icon(
                    _pwvisible ? Icons.visibility_off : Icons.visibility_off,
                  ),
                ),
                labelText: "password ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _pwvisible,
              controller: widget.passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Password field should not be empty";
                } else if (value.length <= 6) {
                  return "password must be 6 character !";
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value as String;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "MPin",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
              controller: widget.mpinController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "mpin shlould not be empty";
                } else if (value.length > 4 || value.length < 4) {
                  return "mpin should be of 4 character";
                }
                return null;
              },
              onSaved: (value) {
                _authData['mpin'] = value as String;
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
