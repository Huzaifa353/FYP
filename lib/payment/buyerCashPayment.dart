import 'package:flutter/material.dart';

class Waiting_screen extends StatefulWidget {
  @override
  _Waiting_screenState createState() => _Waiting_screenState();
}

class _Waiting_screenState extends State<Waiting_screen> {
  // Define variables to store the cash amount and change due
  // Define a text field controller to handle user input
  final cashAmountController = TextEditingController();
  bool _containerVisible = false;
  bool _buttonEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display a prompt for the user to enter the cash amount

              SizedBox(
                height: 20,
              ),

              // Add a button to submit the payment
              Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 230,
                      color: Colors.green,
                    ),
                    Text(
                      'Proceed to Pay the Seller',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
