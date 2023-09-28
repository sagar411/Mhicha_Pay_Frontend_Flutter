import 'package:flutter/material.dart';
import 'package:mhicha_pay_flutter/Screens/save_money_page.dart';
import '../Screens/sendmoney.screen.dart';

class ActivityWidget extends StatelessWidget {
  const ActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      // color: Colors.black,
      child: Row(children: [
        InkWell(
          onHover: (value) {},
          onTap: () {
            Navigator.of(context).pushNamed(SendMoneyScreen.routeName);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: Column(children: [
              Image.asset(
                "assets/images/money.png",
                height: 65,
              ),
              Text("Send Money")
            ]),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(SaveMoneyPage.routeName);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: Column(children: [
              Image.asset(
                "assets/images/piggy.png",
                height: 60,
              ),
              Text("Save Money")
            ]),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: Column(children: [
              Image.asset(
                "assets/images/costs.png",
                height: 60,
              ),
              Text("Get Sapati  ")
            ]),
          ),
        )
      ]),
    );
  }
}
