import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/Screens/dashboard_screen.dart';
import 'package:mhicha_pay_flutter/Widgets/Shared/user_detail.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Models/balance.model.dart';
import '../Widgets/secondary_balance_card.dart';
import '../apis/pdf_api.dart';
import '../apis/pdf_invoice_api.dart';

class SendMoneySuccessPage extends StatelessWidget {
  static String routeName = '/sendMoneySuccessPage';
  const SendMoneySuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPdfDownloaded = false;
    Widget dataWidget(String key, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
          ),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      );
    }

    final fundTransferDetail =
        ModalRoute.of(context)!.settings.arguments as FundTransferModel;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 30,
          ),
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.navigate_before,
                        ),
                      ),
                      const Text(
                        'Transaction Details',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final pdfFile = await PdfInvoiceApi.generate(
                            fundTransferDetail,
                          );
                          Share.shareFiles(
                            [pdfFile.path],
                          );
                        },
                        icon: const Icon(
                          Icons.share,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              UserDetailSharedWidget(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(
                    15,
                  ),
                  color: Colors.black,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      'Send Money',
                                    ),
                                    Text(
                                      fundTransferDetail.time.substring(0, 10),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 7,
                                      ),
                                      color: Colors.orangeAccent,
                                      child: const Text(
                                        'Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  fundTransferDetail.amount.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: dataWidget('Channel:', 'GPRS'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: dataWidget('Data:', '_'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: dataWidget('Transaction Code:',
                                          fundTransferDetail.transactionCode),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: dataWidget(
                                        'Processed By:',
                                        fundTransferDetail.cashFlow == 'In'
                                            ? fundTransferDetail
                                                .senderMhichaEmail
                                            : SharedData.email,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: dataWidget(
                                        'Cash Flow',
                                        fundTransferDetail.cashFlow,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: dataWidget('', ''),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: dataWidget(
                                        'Purpose:',
                                        fundTransferDetail.purpose,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: dataWidget(
                                        'Receiver Username:',
                                        fundTransferDetail.receiverUserName,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: dataWidget(
                                        'Email:',
                                        fundTransferDetail.receiverMhichaEmail,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: dataWidget(
                                        'Sender Name:',
                                        fundTransferDetail.senderUserName,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: dataWidget(
                                          'Payment Method:', 'mhicha Ewallet'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: dataWidget(
                                        'Remarks:',
                                        fundTransferDetail.remarks,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(
                  10,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      DashboardPage.routeName,
                      (route) => false,
                    );
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
