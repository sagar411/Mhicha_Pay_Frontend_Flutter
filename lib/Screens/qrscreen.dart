import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Models/receiver.dart';
import 'package:mhicha_pay_flutter/Models/shared_data.dart';
import 'package:mhicha_pay_flutter/Providers/auth.dart';
import 'package:mhicha_pay_flutter/Screens/sendmoney.screen.dart';
import 'package:mhicha_pay_flutter/Screens/sendmoney_process.dart';
import 'package:mhicha_pay_flutter/Widgets/snackbars.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../Widgets/qr_widget.dart';

class QRPage extends StatefulWidget {
  static String routeName = '/qrPage';
  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? barCode;
  final TextEditingController _userIdController = TextEditingController();
  String userId = '';
  bool qrShowsError = false;

  bool isFlashOn = false;

  Future<void> fetchUser(String email) async {
    print(email);
    try {
      await AuthService.fetchUserByEmail(email).then(
        (value) {
          Navigator.pushReplacementNamed(
            context,
            SendMoneyScreen1.routeName,
            arguments: {
              'email': ReceiverData.ReceiverEmail,
            },
          );
        },
      ).catchError((e) {
        Navigator.pop(context);
        SnackBars.showErrorSnackBar(context, e.toString());
      });
    } on SocketException {
      Navigator.pop(context);
      SnackBars.showErrorSnackBar(context, 'No internet connection.');
    } catch (e) {
      Navigator.pop(context);
      SnackBars.showErrorSnackBar(context, 'No user found.');
    }
  }

  void onQRViewCreated(QRViewController qrViewController) async {
    await qrViewController.resumeCamera();
    setState(() {
      this.qrViewController = qrViewController;
    });
    qrViewController.scannedDataStream.listen((barcode) {
      if (qrShowsError) {
        barCode = barCode;
        _userIdController.text = barcode.code.toString();
        fetchUser(_userIdController.text);
        return;
      }
      if (_userIdController.text.isNotEmpty) {
        return;
      }
      barCode = barCode;
      _userIdController.text = barcode.code.toString();
      fetchUser(_userIdController.text);
      return;
    });
  }

  void showQRBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15,
          ),
          topRight: Radius.circular(
            15,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return const MyQRWidget();
      },
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    qrViewController!.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrViewController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        width: double.infinity,
                        child: QRView(
                          key: _qrKey,
                          onQRViewCreated: onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                            borderRadius: 10,
                            borderLength: 20,
                            borderWidth: 10,
                            borderColor: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 30,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.orange.withOpacity(0.8),
                              Colors.white,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Profile',
                              style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showQRBottomSheet();
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      elevation: 10,
                                      child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Colors.orangeAccent,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.qr_code_scanner_outlined,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'QR Code',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        SendMoneyScreen.routeName,
                                        arguments: {
                                          'isDirectPay': true,
                                          'email': '',
                                        },
                                      );
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      elevation: 10,
                                      child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Colors.orange,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.send_to_mobile_sharp,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Send Money',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                Positioned(
                  top: 10,
                  left: 10,
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.grey,
                    child: const Icon(
                      Icons.navigate_before,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: isFlashOn
                        ? const Icon(
                            Icons.flash_off,
                            size: 30,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.flash_on,
                            size: 30,
                            color: Colors.white,
                          ),
                    onPressed: () async {
                      await qrViewController?.toggleFlash();
                      setState(() {
                        isFlashOn = !isFlashOn;
                      });
                    },
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
