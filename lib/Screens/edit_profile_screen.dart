import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:mhicha_pay_flutter/Widgets/snackbars.dart';

import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  static String routeName = '/editProfilePage';
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String userName = SharedData.name;
  String email = SharedData.email;

  Future<void> updateProfile() async {
    try {
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).updateUserData(userName, email).then((value) {
        SnackBars.showNormalSnackbar(
          context,
          'Profile updated successfully!!!',
        );
      });
    } on SocketException {
      SnackBars.showNoInternetConnectionSnackBar(context);
    } catch (e) {
      SnackBars.showErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (userName == SharedData.name && email == SharedData.email) {
      // SnackBars.showNormalSnackbar(context, 'No changes to save.');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    await updateProfile();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.289,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.orange,
                                  const Color(0xff018AF3),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.navigate_before,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 100,
                            right: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: Provider.of<UserProvider>(context)
                                    .myDetail
                                    .name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Username can\'t be empty';
                                  }
                                  if (value.length <= 6) {
                                    return 'Username should  be at least 7 characters.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      // borderSide: BorderSide(
                                      //     width: 1.5,
                                      //     color:
                                      //         Provider.of<ThemeProvider>(context)
                                      //                 .isDarkMode
                                      //             ? Colors.white60
                                      //             : Colors.black54),
                                      // borderRadius: BorderRadius.circular(
                                      //   10,
                                      // ),
                                      ),
                                  // errorBorder: errorBorder,
                                  // focusedBorder: focusedBorder,
                                  // focusedErrorBorder: focusedErrorBorder,
                                  label: const AutoSizeText(
                                    'Username',
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                  ),
                                ),
                                onSaved: (text) {
                                  userName = text!;
                                },
                                onChanged: (text) {
                                  userName = text;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                enabled: false,
                                initialValue: Provider.of<UserProvider>(context)
                                    .myDetail
                                    .email,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@') ||
                                      !value.endsWith('.com')) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  // border: border,
                                  enabledBorder: OutlineInputBorder(
                                      //   borderSide: BorderSide(
                                      //     width: 1.5,
                                      //     color: Provider.of<ThemeProvider>(context)
                                      //             .isDarkMode
                                      //         ? Colors.white60
                                      //         : Colors.black54,
                                      //   ),
                                      //   borderRadius: BorderRadius.circular(
                                      //     10,
                                      //   ),
                                      ),
                                  // errorBorder: errorBorder,
                                  // focusedBorder: focusedBorder,
                                  // focusedErrorBorder: focusedErrorBorder,
                                  label: const AutoSizeText(
                                    'Email',
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.mail_outline,
                                  ),
                                ),
                                onSaved: (text) {
                                  email = text!;
                                },
                                onChanged: (text) {
                                  email = text;
                                },
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                              Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    await _saveForm();
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: Center(
                                      child: _isLoading
                                          ? const CircularProgressIndicator()
                                          : const AutoSizeText(
                                              'Update Profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.189,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // AddImageWidget(
                      //   getUserProfilePhoto: () {},
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
