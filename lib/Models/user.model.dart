class UserModel {
  String name;
  String email;
  String role;
  String mpin;
  double balance;
  double sapati;
  double saving;

  bool twofactor;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.mpin,
    required this.balance,
    required this.sapati,
    required this.saving,
    required this.twofactor,
  });
}
