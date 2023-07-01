import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignupFormSubmit extends StatefulWidget {
  const SignupFormSubmit({super.key});

  @override
  State<SignupFormSubmit> createState() => SignupFormSubmitState();
}

class SignupFormSubmitState extends State<SignupFormSubmit> {
  final GlobalKey<FormState> _fromKey = GlobalKey();
  Map<String, String> _authData = {"name": "", "password": "", "mpin": ""};
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mpinController = TextEditingController();
  bool _pwvisible = true;

  void _submit() async {
    final isValid = _fromKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _fromKey.currentState!.save();
  }

  Function get submitForm {
    return _submit;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _fromKey,
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
              controller: _nameController,
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
              controller: _passwordController,
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
              controller: _mpinController,
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
