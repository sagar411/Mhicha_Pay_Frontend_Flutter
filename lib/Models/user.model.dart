class UserModel {
  String name;
  String email;
  String role;
  String mpin;
  int balance;
  int sapati;
  int saving;

  bool kyc;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.mpin,
    required this.balance,
    required this.sapati,
    required this.saving,
    required this.kyc,
  });
}
