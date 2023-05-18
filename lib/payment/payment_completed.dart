import 'package:flutter/material.dart';
import 'package:mazdoor_pk/payment/RatingBar.dart';

class PaymentCompleted extends StatefulWidget {
  final String BID, SID;
  final double totalBill;
  String message = "Rate the seller";
  String category = "Plumber";
  String Seller_name = "Huzaifa", Buyer_name = "Vinesh";

  PaymentCompleted(this.BID, this.SID, this.totalBill, this.message,
      this.category, this.Seller_name, this.Buyer_name);

  @override
  State<PaymentCompleted> createState() => _PaymentCompleted(
      BID, SID, totalBill, message, category, Seller_name, Buyer_name);
}

class _PaymentCompleted extends State<PaymentCompleted> {
  var BID;
  var SID;
  var totalBill;
  var message;
  var category;
  var Seller_name;
  var Buyer_name;
  double _currentRating = 0;

  _PaymentCompleted(this.BID, this.SID, this.totalBill, this.message,
      this.category, this.Seller_name, this.Buyer_name);

  DateTime Date = DateTime.now();
  void _onRatingChanged(int rating) {
    _currentRating = rating.toDouble();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 35,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      'PAID',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                Row(
                  children: [
                    Text(
                      'PKR $totalBill',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  child: Divider(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      widget.message,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                RatingBar(
                  starCount: 5,
                  onRatingChanged: _onRatingChanged,
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(34, 205, 142, 1.0),
                    ),
                    onPressed: () {
                      print(_currentRating); // add to database
                    },
                    child: const Text(
                      'Submit feedback',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
              'View Reciept',
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
