import 'package:flutter/material.dart';
import '../Screens/signup_screen.dart';
import '../Providers/auth.dart';
import '../Screens/profile_screen.dart';
import '../Models/shared_data.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = true;

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      await Auth.authenticate(_emailController.text, _passwordController.text)
          .then((value) {
        if (SharedData.token.isNotEmpty && SharedData.userId.isNotEmpty) {
          Navigator.of(context).pushNamed(ProfileScreen.routeName);
        } else {
          print("sorry couldn't login");
        }
      });
    } catch (error) {
      print("Error");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
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
              _authData['email'] = value as String;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                child: Icon(
                    _passwordVisible ? Icons.visibility_off : Icons.visibility),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _passwordController,
            obscureText: _passwordVisible,
            validator: (value) {
              if (value!.isEmpty || value.length < 6) {
                return "passwrod is too short !";
              }
            },
            onSaved: (value) {
              _authData['password'] = value as String;
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: _submit,
              child: Text("Forget Password ?"),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity, 60)), // Set the minimum size
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(16),
              ), // Set the padding
            ),
            onPressed: _submit,
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 234, 227, 227),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                const Size(double.infinity, 60),
              ), // Set the minimum size
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(16),
              ), // Set the padding
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(SignupScreen.routeName);
            },
            child: Text(
              "SignUp",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}