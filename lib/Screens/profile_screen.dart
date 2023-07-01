import 'package:flutter/material.dart';
import '../Models/shared_data.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/balance_widget.dart';

class ProfileScreen extends StatelessWidget {
  static final routeName = "/profile";
  const ProfileScreen({super.key});
  String getFirstName(String fullname) {
    int spaceIndex = fullname.indexOf(' ');
    if (spaceIndex != -1) {
      return fullname.substring(0, spaceIndex);
    } else {
      return fullname;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(249, 251, 248, 248),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          padding: EdgeInsets.all(15),
          alignment: Alignment.topLeft,
          onPressed: () {},
          icon: Icon(
            Icons.menu_rounded,
            color: Color.fromARGB(255, 70, 69, 69),
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Hi, ${getFirstName(SharedData.name)}!",
                style: GoogleFonts.heebo(
                  fontSize: 23,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: BalanceWidget(),
            )
          ],
        ),
      ),
    );
  }
}
