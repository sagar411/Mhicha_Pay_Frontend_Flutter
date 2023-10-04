import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Providers/auth.dart';
import 'package:mhicha_pay_flutter/Providers/sapati.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:mhicha_pay_flutter/Screens/savings_page.dart';
import 'package:mhicha_pay_flutter/Widgets/Shared/user_detail.dart';
import 'package:mhicha_pay_flutter/Widgets/snackbars.dart';
import 'package:provider/provider.dart';

class AdminDashboardPage extends StatefulWidget {
  static String routeName = '/admin-dashboard';
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello Admin !',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AuthService.logOut(context);
                    },
                    child: Text('Log Out'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: UserDetailSharedWidget(),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: SapatiRequests())
          ],
        ),
      ),
    );
  }
}

class SapatiRequests extends StatefulWidget {
  const SapatiRequests({super.key});

  @override
  State<SapatiRequests> createState() => _SapatiRequestsState();
}

class _SapatiRequestsState extends State<SapatiRequests> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<SapatiProvider>(context, listen: false)
            .getSapatiRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Consumer<SapatiProvider>(builder: (context, data, child) {
            if (data.sapatis.isEmpty) {
              return const Center(
                child: Text('You have no sapatis till date.'),
              );
            }
            return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                itemCount: data.sapatis.length,
                itemBuilder: (context, i) {
                  return ChangeNotifierProvider<Sapati>.value(
                    value: data.sapatis[i],
                    child: const SapatiWidget1(),
                  );
                });
          });
        });
  }
}

class SapatiWidget1 extends StatelessWidget {
  const SapatiWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    final sapati = Provider.of<Sapati>(context);
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            5,
          ),
          color: Colors.grey.withOpacity(
            0.6,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(
                5,
              ),
              // color: Provider.of<ThemeProvider>(context).isDarkMode
              //     ? Colors.white
              //     : Colors.black,
              color: Colors.black,
              child: SizedBox(
                height: 35,
                width: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  child: const Image(
                    image: AssetImage(
                      'assets/images/icon2.png',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rs. ${sapati.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    sapati.purpose,
                    // widget.statement.time,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  // Icons.arrow_drop_up,
                  // color: widget.statement.cashFlow == 'In'
                  //     ? Colors.green
                  //     : Colors.red,
                  // ),

                  if (!sapati.paid && !sapati.approvedByAdmin)
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Are you Sure?'),
                              content: const Text(
                                'Do you want to approve your sapati?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    await sapati
                                        .approveSapatiRequest(
                                            sapati.id, sapati.purpose)
                                        .then((value) {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .userData();
                                      SnackBars.showNormalSnackbar(context,
                                          'Request approved successfully.');
                                    }).catchError(
                                      (e) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'An error occurred!'),
                                              content: Text(
                                                e.toString(),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Okay'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Approve',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (!sapati.paid && sapati.approvedByAdmin)
                    Text(
                      'Approved',
                      style: TextStyle(color: Colors.blue),
                    ),
                  if (sapati.paid && sapati.approvedByAdmin)
                    Text(
                      'Sapati Paid',
                      style: TextStyle(color: Colors.green),
                    ),
                  Text(
                    sapati.userName,
                    // widget.statement.time,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
