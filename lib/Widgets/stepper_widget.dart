import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/Providers/auth.dart';
import '../Widgets/signup_submit_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/main_screen.dart';

class SteppersWidget extends StatefulWidget {
  // final Final
  const SteppersWidget({super.key});

  @override
  State<SteppersWidget> createState() => _SteppersWidgetState();
}

class _SteppersWidgetState extends State<SteppersWidget> {
  final GlobalKey<FormState> _formKeySignup = GlobalKey();

  final thirdStepNameController = TextEditingController();
  final thirdStepPasswordController = TextEditingController();
  final thirdStepMpinController = TextEditingController();

  void thirdStepsubmit() async {
    final isValid = _formKeySignup.currentState!.validate();
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!isValid) {
      return;
    }
    try {
      await Auth.finalSubmit(
        thirdStepNameController.text,
        SharedData.email,
        thirdStepPasswordController.text,
        thirdStepMpinController.text,
      ).then((value) => {
            if (SharedData.token.isNotEmpty || SharedData.userId.isNotEmpty)
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "Account Created Successfully",
                    style: TextStyle(color: Colors.green),
                  ),
                )),
                Navigator.of(context).pushNamed(MainScreen.routeName)
              }
          });
    } catch (error) {
      await ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }

    _formKeySignup.currentState!.save();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  Map<String, String> _authData = {
    "email": " ",
  };
  int statusCode = 0;
  //email
  int _currentStep = 0;
  final emailController = TextEditingController();
  bool formValidate = false;
  //otp
  bool otpCheck = false;

  // timer
  bool _isButtonEnabled = false;
  Timer? _timer;
  int _secondsLeft = 120;

  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (_secondsLeft == 0) {
          _timer?.cancel();
          setState(() {
            _isButtonEnabled = true;
          });
        } else {
          setState(() {
            _secondsLeft--;
          });
        }
      },
    );
  }

  void _handleButtonClick() {}
  void calnceTimer() {
    _timer?.cancel();
  }

//email valid step1
  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      setState(() {
        formValidate = true;
      });
      _formKey.currentState!.save();

      try {
        await Auth.sendOTP(emailController.text).then((value) {
          setState(() {
            statusCode = value;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Otp had been sent to ${emailController.text}"),
        ));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
        ));
      }
    }
  }

  String getOtpValue() {
    String otpValue = '';
    for (var controller in otpControllers) {
      otpValue += controller.text;
    }
    return otpValue;
  }

//otp verify step-2
  Future<void> _submitOtp() async {
    String otpValue = getOtpValue();
    // print("otp Vlue");
    // print(otpValue);

    try {
      if (otpValue.isNotEmpty) {
        // print("here");
        await Auth.checkOtpValidation(SharedData.email, otpValue).then((value) {
          if (value) {
            setState(() {
              otpCheck = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Otp Verified",
                style: TextStyle(color: Colors.green),
              ),
            ));
          }
          ;
        });
      }
    } catch (error) {
      var newErr = await error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newErr as String),
        ),
      );
    }
  }

  cancelStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep = _currentStep - 1;
      });
    }
    // if (_currentStep < 0) {}
  }

  continueStep() async {
    if (_currentStep == 0) {
      _submit().then((value) {
        if (statusCode == 200 || statusCode == 201) {
          if (!formValidate) {
            return;
          } else {
            setState(() {
              print(_currentStep);
              _currentStep++;
            });
            _startTimer();
          }
        } else {
          return;
        }
      });
    } else if (_currentStep == 1) {
      await _submitOtp().then((value) {
        if (!otpCheck) {
          return;
        } else {
          setState(() {
            _currentStep++;
          });
          for (var controller in otpControllers) {
            controller.clear();
          }
        }
      });
    } else if (_currentStep == 2) {
      thirdStepsubmit();
    }
  }

  Widget controlBuilder(context, details) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: details.onStepContinue,
          child: Text("Next"),
        ),
        SizedBox(
          width: 10,
        ),
        OutlinedButton(
          onPressed: details.onStepCancel,
          child: Text("back"),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _currentStep,
      onStepContinue: continueStep,
      onStepCancel: cancelStep,
      controlsBuilder: controlBuilder,
      steps: [
        Step(
            title: Text("Verify"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
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
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.disabled),
        Step(
            title: Text("Otp"),
            content: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: otpControllers[0],
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: otpControllers[1],
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: otpControllers[2],
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: otpControllers[3],
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: otpControllers[4],
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextFormField(
                            controller: otpControllers[5],
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.visiblePassword,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: _isButtonEnabled ? _handleButtonClick : null,
                      child: Text(_isButtonEnabled
                          ? "Resend OTP"
                          : "Resend OTP ($_secondsLeft seconds)"))
                ],
              ),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled),
        Step(
          title: Text("Submit Form"),
          content: SignupFormSubmit(
            nameController: thirdStepNameController,
            passwordController: thirdStepPasswordController,
            mpinController: thirdStepMpinController,
            formKey: _formKeySignup,
          ),
          isActive: _currentStep >= 2,
          state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
        ),
      ],
    );
  }
}
