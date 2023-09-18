import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Screens/main_screen.dart';
import 'package:mhicha_pay_flutter/Screens/qrscreen.dart';
import 'package:mhicha_pay_flutter/Screens/statementspage.dart';

class DashboardPage extends StatefulWidget {
  static String routeName = '/dashboardPage';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentTab = 0;

  final PageStorageBucket bucket = PageStorageBucket();

  Widget bottomNavItem(int tab, String label, IconData icon, Function onTap) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      minWidth: 40,
      onPressed: () {
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentTab == tab ? Colors.orange : Colors.grey,
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: currentTab == tab ? Colors.orange : Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // void goToStatementsPage() {
  //   setState(() {
  //     currentScreen = StatementsPage(
  //       returnToPreviousFunction: returnToPreviousPage,
  //     );
  //     currentTab = 1;
  //   });
  // }

  void returnToPreviousPage() {
    setState(() {
      currentScreen = MainScreen();
      currentTab = 0;
    });
  }

  late Widget currentScreen;

  @override
  void initState() {
    currentScreen = MainScreen(
        // goToStatementsPage: goToStatementsPage,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            Navigator.of(context).pushNamed(QRPage.routeName);
          },
          child: const Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 70,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: bottomNavItem(0, 'Home', Icons.home_rounded, () {
                      setState(() {
                        currentScreen = MainScreen();
                        currentTab = 0;
                      });
                    }),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: bottomNavItem(1, 'Statements', Icons.book, () {
                      setState(() {
                        currentScreen = StatementsPage(
                          returnToPreviousFunction: returnToPreviousPage,
                        );
                        currentTab = 1;
                      });
                    }),
                  ),
                ),
                const SizedBox(
                  width: 70,
                ),
                Expanded(
                  child: Center(
                    child: bottomNavItem(2, 'Payments', Icons.payment, () {
                      setState(() {
                        // currentScreen = const PaymentsPage();
                        currentTab = 2;
                      });
                    }),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: bottomNavItem(3, 'Settings', Icons.settings, () {
                      setState(() {
                        // currentScreen = SettingsPage(
                        //   returnToPreviousFunction: returnToPreviousPage,
                        // );
                        currentTab = 3;
                      });
                    }),
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
