import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/payment/NumberButton.dart';
import 'package:mazdoor_pk/payment/payment_completed.dart';

class CashPaymentScreen extends StatefulWidget {
  final String PID;
  final String BID, SID;
  final double totalBill;
  CashPaymentScreen(
      {required this.PID,
      required this.BID,
      required this.SID,
      required this.totalBill});

  @override
  _CashPaymentScreenState createState() =>
      _CashPaymentScreenState(BID, SID, totalBill);
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  // Define variables to store the cash amount and change due
  var BID;
  var SID;
  late String buyer;
  late String seller;
  late String category;
  var totalBill;
  var amount_entered = 0.0;

  _CashPaymentScreenState(this.BID, this.SID, this.totalBill);
  // Define a text field controller to handle user input
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> Pay() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("Product")
        .doc(widget.PID)
        .get();

    category = snapshot.data()?['category'] ?? "Electrician";

    var productRef = snapshot.reference;

    productRef.update({'status': 'paid'});

    var buyerSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: BID)
        .get();
    var sellerSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: SID)
        .get();

    buyer = buyerSnapshot.docs.first['name'];
    seller = sellerSnapshot.docs.first['name'];

    double balance =
        amount_entered - totalBill + buyerSnapshot.docs.first['money'];

    var userRef = buyerSnapshot.docs.first.reference;

    userRef.update({'money': balance});
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(34, 205, 142, 1.0),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Amount to Pay: PKR $totalBill',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display a prompt for the user to enter the cash amount
                    const Text(
                      'Enter Cash Amount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),

                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _textEditingController,
                            focusNode: _focusNode,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0.00',
                            ),
                            style: const TextStyle(fontSize: 24),
                            onTap: () {
                              // Disable keyboard when text field is tapped
                              _focusNode.unfocus();
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                NumberButton('1', onPressed: () {
                                  _textEditingController.text += '1';
                                }, number: '1'),
                                const SizedBox(width: 6),
                                NumberButton('2', onPressed: () {
                                  _textEditingController.text += '2';
                                }, number: '2'),
                                const SizedBox(width: 6),
                                NumberButton('3', onPressed: () {
                                  _textEditingController.text += '3';
                                }, number: '3'),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NumberButton(
                                  '4',
                                  onPressed: () {
                                    _textEditingController.text += '4';
                                  },
                                  number: '4',
                                ),
                                SizedBox(width: 6),
                                NumberButton('5', onPressed: () {
                                  _textEditingController.text += '5';
                                }, number: '5'),
                                SizedBox(width: 6),
                                NumberButton('6', onPressed: () {
                                  _textEditingController.text += '6';
                                }, number: '6'),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NumberButton('7', onPressed: () {
                                  _textEditingController.text += '7';
                                }, number: '7'),
                                const SizedBox(width: 6),
                                NumberButton('8', onPressed: () {
                                  _textEditingController.text += '8';
                                }, number: '8'),
                                const SizedBox(width: 6),
                                NumberButton('9', onPressed: () {
                                  _textEditingController.text += '9';
                                }, number: '9'),
                              ],
                            ),
                            const SizedBox(height: 7),
                            NumberButton('0', onPressed: () {
                              _textEditingController.text += '0';
                            }, number: '0'),
                          ],
                        ),
                        Column(
                          children: [
                            NumberButton(
                              '<-',
                              onPressed: () {
                                String currentValue =
                                    _textEditingController.text;
                                if (currentValue.length > 0) {
                                  String newValue = currentValue.substring(
                                      0, currentValue.length - 1);
                                  _textEditingController.text = newValue;
                                  _textEditingController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: newValue.length));
                                }
                              },
                              number: '<-',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          amount_entered =
                              double.parse(_textEditingController.text);
                          if (amount_entered >= totalBill) {
                            Pay();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentCompleted(
                                        BID,
                                        SID,
                                        totalBill,
                                        '',
                                        category,
                                        seller,
                                        buyer)));

                            // Add to database  (amount_entered)
                            //
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Amount entered less than the amount to pay.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Pay Now',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
