import 'package:flutter/material.dart';
import 'package:mazdoor_pk/payment/cashpayment.dart';
import 'package:mazdoor_pk/payment/paymentCard.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

// ignore: camel_case_types
class Payment_NavBar extends StatefulWidget {
  String BID; // BUYER ID
  String SID; // Seller ID
  double totalBill = 0.0;
  String message = "Rate the seller";
  String category = "Plumber";
  String Seller_name = "Huzaifa", Buyer_name = "Vinesh";

  Payment_NavBar({
    required this.BID,
    required this.SID,
    required this.totalBill,
    required this.message,
    required this.category,
    required this.Seller_name,
    required this.Buyer_name,
  });
  @override
  State<Payment_NavBar> createState() => Payment_NavBarState(
      BID, SID, totalBill, message, category, Seller_name, Buyer_name);
}

// ignore: camel_case_types
class Payment_NavBarState extends State<Payment_NavBar> {
  var BID;
  var SID;
  var totalBill;
  var message;
  var category;
  var Seller_name;
  var Buyer_name;
  Payment_NavBarState(this.BID, this.SID, this.totalBill, this.message,
      this.category, this.Seller_name, this.Buyer_name);

  @override
  Widget build(BuildContext context) {
    int _selected_index = 0;
    PageController _pageController = PageController();

    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            Center(child: CardPayment()),
            Center(
                child: CashPaymentScreen(BID, SID, totalBill, message, category,
                    Seller_name, Buyer_name)),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: GNav(
              duration: const Duration(milliseconds: 500),
              //tabBackgroundColor: Color.fromARGB(255, 80, 232, 176),
              gap: 5,
              tabBorderRadius: 20,
              tabBackgroundColor: Color.fromARGB(255, 80, 232, 176),
              color: Colors.black,
              iconSize: 23,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              activeColor: Colors.black,
              selectedIndex: _selected_index,
              onTabChange: (index) {
                setState(() {
                  _selected_index = index;
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease);
                });
              },
              tabs: const [
                GButton(
                  icon: LineIcons.creditCard,
                  text: 'Card Payment',
                ),
                GButton(
                  icon: LineIcons.moneyBill,
                  text: 'Cash Payment',
                ),
              ],
            ),
          ),
        ));
  }
}
