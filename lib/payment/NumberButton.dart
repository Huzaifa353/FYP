import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback onPressed;

  const NumberButton(
    String s, {
    Key? key,
    required this.number,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.0,
      height: 50.0,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        onPressed: onPressed,
        child: Text(
          number.toString(),
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
