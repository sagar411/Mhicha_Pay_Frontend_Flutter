import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Providers/savings.dart';
import 'package:provider/provider.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Savings',
        ),
      ),
      body: FutureBuilder(
          future:
              Provider.of<SavingsProvider>(context, listen: false).getSaving(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.connectionState == snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Consumer<SavingsProvider>(builder: (context, data, child) {
              return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  itemCount: data.savings.length,
                  itemBuilder: (context, i) {
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
                                    'Rs. ${data.savings[i].savingAmount}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    data.savings[i].purpose,
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
                                  if (!data.savings[i].paid)
                                    TextButton.icon(
                                      label: Text(
                                        'Withdraw',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.payment,
                                        color: Colors.green,
                                      ),
                                    ),
                                  if (data.savings[i].paid)
                                    Text(
                                      'Paid',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.green),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            });
          }),
    );
  }
}
