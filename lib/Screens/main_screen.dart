import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:mhicha_pay_flutter/Screens/statement_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Providers/statements_provider.dart';
import '../Widgets/balance_widget.dart';
import '../Widgets/activity_widget.dart';
import '../Widgets/statement_widget.dart';

class MainScreen extends StatefulWidget {
  static final routeName = "/profile";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    Provider.of<UserProvider>(context, listen: false).userData();
    // });
    super.initState();
  }

  String getFirstName(String fullname) {
    int spaceIndex = fullname.indexOf(' ');
    if (spaceIndex != -1) {
      return fullname.substring(0, spaceIndex);
    } else {
      return fullname;
    }
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print('pheri running');
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
            Icons.menu,
            color: Color.fromARGB(255, 70, 69, 69),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            children: <Widget>[
              Consumer<UserProvider>(builder: (context, userData, _) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Hi, ${getFirstName(userData.myDetail.name)}!",
                    style: GoogleFonts.heebo(
                        fontSize: 27, fontWeight: FontWeight.w700),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: BalanceWidget(),
              ),
              const SizedBox(
                height: 20,
              ),
              ActivityWidget(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future:
                      Provider.of<StatementsProvider>(context, listen: false)
                          .getStatements('All'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Consumer<StatementsProvider>(
                      builder: (context, statementsData, child) {
                        return statementsData.statements.isEmpty
                            ? const Text(
                                'No statements available!!!.',
                              )
                            : Column(
                                children: statementsData.recentStatements
                                    .map((statement) {
                                  return StatementWidget(
                                    statement: statement,
                                  );
                                }).toList() as List<Widget>,
                              );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
