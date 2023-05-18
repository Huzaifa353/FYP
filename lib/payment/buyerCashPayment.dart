import 'package:flutter/material.dart';
import 'package:mazdoor_pk/payment/NavBar.dart';

class WaitingScreen extends StatefulWidget {
  double price;
  WaitingScreen(this.price);

  @override
  State<WaitingScreen> createState() => WatingScreen();
}

class WatingScreen extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SizedBox(
          height: double.maxFinite,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(34, 205, 142, 1.0),
            ),
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rs. ' + widget.price.toString() + '/-',
                  style: const TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  'Proceed to Pay the Seller',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
