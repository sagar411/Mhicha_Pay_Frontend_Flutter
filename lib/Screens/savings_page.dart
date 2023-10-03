import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Providers/sapati.dart';
import 'package:mhicha_pay_flutter/Providers/savings.dart';
import 'package:mhicha_pay_flutter/Providers/user.provider.dart';
import 'package:mhicha_pay_flutter/Widgets/snackbars.dart';
import 'package:provider/provider.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'Savings',
        //   ),
        // ),
        body: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.savings),
                ),
                Tab(
                  icon: Icon(
                    Icons.payment,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: TabBarView(
              children: [
                Savings(),
                Sapatis(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class Savings extends StatefulWidget {
  const Savings({super.key});

  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<SavingsProvider>(context, listen: false).getSaving(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Consumer<SavingsProvider>(builder: (context, data, child) {
            if (data.savings.isEmpty) {
              return const Center(
                child: Text('You have no savings till date.'),
              );
            }
            return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                itemCount: data.savings.length,
                itemBuilder: (context, i) {
                  return ChangeNotifierProvider<Saving>.value(
                    value: data.savings[i],
                    child: const SavingWidget(),
                  );
                });
          });
        });
  }
}

class Sapatis extends StatefulWidget {
  const Sapatis({super.key});

  @override
  State<Sapatis> createState() => _SapatisState();
}

class _SapatisState extends State<Sapatis> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<SapatiProvider>(context, listen: false).getSapatiList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == snapshot.hasError) {
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
                    child: const SapatiWidget(),
                  );
                });
          });
        });
  }
}

class SavingWidget extends StatelessWidget {
  const SavingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final saving = Provider.of<Saving>(context);
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
                    'Rs. ${saving.savingAmount}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    saving.purpose,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  // Icons.arrow_drop_up,
                  // color: widget.statement.cashFlow == 'In'
                  //     ? Colors.green
                  //     : Colors.red,
                  // ),
                  if (!saving.paid)
                    TextButton.icon(
                      label: Text(
                        'Withdraw',
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        // saving.changePaidStatus(saving.id, saving.purpose);
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Are you Sure?'),
                              content: const Text(
                                'Do you want to withdraw your saving?',
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

                                    await saving
                                        .changePaidStatus(
                                            saving.id, saving.purpose)
                                        .then((value) {
                                      SnackBars.showNormalSnackbar(context,
                                          'Savings withdrawn successfully');
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .userData();
                                    }).catchError(
                                      (e) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'An error occurred!'),
                                              content: const Text(
                                                'Something went wrong.',
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
                      icon: Icon(
                        Icons.payment,
                        color: Colors.green,
                      ),
                    ),

                  if (saving.paid)
                    Text(
                      'Paid',
                      style: TextStyle(fontSize: 15, color: Colors.red),
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

class SapatiWidget extends StatelessWidget {
  const SapatiWidget({super.key});

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  // Icons.arrow_drop_up,
                  // color: widget.statement.cashFlow == 'In'
                  //     ? Colors.green
                  //     : Colors.red,
                  // ),

                  if (!sapati.paid && sapati.approvedByAdmin)
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Are you Sure?'),
                              content: const Text(
                                'Do you want to pay up your sapati?',
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
                                        .payBackSapati(
                                            sapati.id, sapati.purpose)
                                        .then((value) {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .userData();
                                      SnackBars.showNormalSnackbar(context,
                                          'Sapati paid out successfully');
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
                        'Pay Back',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (!sapati.paid && !sapati.approvedByAdmin)
                    Text(
                      'Pending',
                      style: TextStyle(color: Colors.blue),
                    ),
                  if (sapati.paid)
                    Text(
                      'Sapati Paid',
                      style: TextStyle(color: Colors.green),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
