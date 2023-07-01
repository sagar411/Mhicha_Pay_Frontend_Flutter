import "package:flutter/material.dart";
import "package:mhicha_pay_flutter/Models/shared_data.dart";

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 175,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  "Your Balance",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "Rs. ${SharedData.balance}",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        SizedBox(
          width: 25,
        ),
        Container(
          height: 175,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.primary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "Your Balance",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "Rs. ${SharedData.balance}",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
