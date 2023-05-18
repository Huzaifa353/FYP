import 'package:flutter/material.dart';
import 'package:mazdoor_pk/payment/NavBar.dart';

class Invoice extends StatefulWidget {
  final String BID; // BUYER ID
  final String SID; // Seller ID
  final String PID; // Seller ID
  final double totalBill;
  String message = "Rate the seller";
  String category = "Plumber";
  String Seller_name = "Huzaifa", Buyer_name = "Vinesh";

  Invoice(
      {required this.SID,
      required this.BID,
      required this.PID,
      required this.totalBill,
      required this.message,
      required this.category,
      required this.Seller_name,
      required this.Buyer_name});

  @override
  State<Invoice> createState() =>
      _Invoice(BID, SID, totalBill, message, category, Seller_name, Buyer_name);
}

class _Invoice extends State<Invoice> {
  var BID;
  var SID;
  var totalBill;
  var message;
  var category;
  var Seller_name;
  var Buyer_name;

  _Invoice(this.BID, this.SID, this.totalBill, this.message, this.category,
      this.Seller_name, this.Buyer_name);

  DateTime Date = DateTime.now();

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${Date.day}/${Date.month}/${Date.year}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Buyer Name:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        widget.Buyer_name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seller Name:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        widget.Seller_name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        widget.category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Total Bill',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PKR $totalBill',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(34, 205, 142, 1.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Payment_NavBar(
                                    PID: widget.PID,
                                    BID: BID,
                                    SID: SID,
                                    totalBill: totalBill,
                                    message: message,
                                    category: category,
                                    Seller_name: Seller_name,
                                    Buyer_name: Buyer_name)));
                      },
                      child: const Text(
                        'Receipt',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
  }

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
              primary: Color.fromRGBO(34, 205, 142, 1.0),
            ),
            onPressed: () {
              _showDialog();
            },
            child: const Text(
              'Proceed to Payment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
