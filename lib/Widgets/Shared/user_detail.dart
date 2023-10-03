import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/user.provider.dart';

class UserDetailSharedWidget extends StatelessWidget {
  const UserDetailSharedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      height: 100,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.9),
              Theme.of(context).colorScheme.primary.withOpacity(0.8)
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Consumer<UserProvider>(builder: (context, value, child) {
            return Align(
              alignment: Alignment.topRight,
              child: Text(
                value.myDetail.name,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            );
          }),
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 35,
              ),
              const SizedBox(
                width: 15,
              ),
              Consumer<UserProvider>(builder: (context, value, child) {
                return Text(
                  "Rs. ${value.myDetail.balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}
