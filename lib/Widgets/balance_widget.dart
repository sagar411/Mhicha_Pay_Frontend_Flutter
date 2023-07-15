import "package:flutter/material.dart";
import "package:mhicha_pay_flutter/Providers/user.provider.dart";
import "package:provider/provider.dart";

class BalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            height: 175,
            width: 180,
            padding: EdgeInsets.all(10),
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
              // Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    child: Icon(Icons.account_balance),
                  ),
                ),

                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Your Balance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),

                Consumer<UserProvider>(
                  builder: (context, value, _) {
                    return Text(
                      "Rs. ${value.myDetail.balance}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                //
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            height: 175,
            width: 180,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.savings)),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Your Savings",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                Consumer<UserProvider>(
                  builder: (context, value, _) {
                    return Text(
                      "Rs. ${value.myDetail.saving}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    );
                  },
                )
              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            height: 175,
            width: 180,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black.withOpacity(0.76),
            ),
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                      // backgroundColor: Colors.black,
                      child: Icon(Icons.credit_card)),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Your Sapati",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Consumer<UserProvider>(
                  builder: (context, value, _) {
                    return Text(
                      "Rs. ${value.myDetail.sapati}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
