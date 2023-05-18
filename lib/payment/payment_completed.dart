import 'package:flutter/material.dart';
import 'package:mazdoor_pk/homeProducts.dart';
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
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    const Text(
                      'PAID',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
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
                    const Text(
                      'Date:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${Date.day}/${Date.month}/${Date.year}',
                      style: const TextStyle(
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
                    const Text(
                      'Buyer Name:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.Buyer_name,
                      style: const TextStyle(
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
                    const Text(
                      'Seller Name:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.Seller_name,
                      style: const TextStyle(
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
                    const Text(
                      'Category:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.category,
                      style: const TextStyle(
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
                      style: const TextStyle(
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
                (message != "")
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.message,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          RatingBar(
                            starCount: 5,
                            onRatingChanged: _onRatingChanged,
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromRGBO(34, 205, 142, 1.0),
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
                          )
                        ],
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(10, 10, 10, 1),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeProducts())); // add to database
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
              primary: const Color.fromRGBO(34, 205, 142, 1.0),
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
