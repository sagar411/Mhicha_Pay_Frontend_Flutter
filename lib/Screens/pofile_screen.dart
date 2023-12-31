import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/Providers/auth.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:mhicha_pay_flutter/Screens/edit_profile_screen.dart';

import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/profilePage';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget profileDetailBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          label,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        AutoSizeText(
          value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theHeight = MediaQuery.of(context).size.height;
    final theWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: theHeight * 0.230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(
                        55,
                      ),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.red,
                        const Color(0xff018AF3),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 60,
                            top: 65,
                            right: 40,
                            bottom: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              profileDetailBox(
                                'Your email',
                                SharedData.email,
                              ),
                              profileDetailBox('Your password', '*********'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Two Factor Authentication',
                                  ),
                                  Consumer<UserProvider>(
                                    builder: (context, data, child) {
                                      return Switch(
                                        value: data.myDetail.twofactor,
                                        onChanged: (value) {
                                          data.toggleTwoFactor();
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: theHeight * 0.13,
              left: theWidth * 0.09,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: 'profileImage',
                    child: CircleAvatar(
                      radius: theWidth * 0.14,
                      backgroundColor: Colors.orangeAccent.withOpacity(
                        0.6,
                      ),
                      child: CircleAvatar(
                        radius: theWidth * 0.135,
                        backgroundColor: Colors.black12,
                        backgroundImage: const AssetImage(
                          'assets/images/profile.jpg',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -14,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.verified_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              AutoSizeText(
                                'Verified',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: theHeight * 0.168,
              left: theWidth * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    Provider.of<UserProvider>(
                      context,
                    ).myDetail.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: theHeight * 0.008,
              left: 30,
              child: TextButton(
                onPressed: () async {
                  await AuthService.logOut(context);
                },
                child: const AutoSizeText(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 5,
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, EditProfilePage.routeName);
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 5,
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.navigate_before,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
