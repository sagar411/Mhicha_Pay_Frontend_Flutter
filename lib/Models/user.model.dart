import 'package:flutter/material.dart';

class UserModel {
  String id;
  String name;
  String email;
  String? role;
  String mpin;
  double balance;
  bool kyc;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      this.role,
      required this.mpin,
      required this.balance,
      required this.kyc});
}
