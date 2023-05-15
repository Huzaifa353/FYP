import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/RemainingTime.dart';
import 'package:mazdoor_pk/homeProducts.dart';

// ignore: camel_case_types
class ProductView extends StatefulWidget {
  final title;
  final description;
  final sellerEmail;
  final basePrice;
  final actualPrice;
  final category;
  final seller;
  final image;
  final time;
  final id;

  const ProductView({
    Key? key,
    required this.title,
    required this.sellerEmail,
    required this.description,
    required this.basePrice,
    required this.actualPrice,
    required this.category,
    required this.seller,
    required this.image,
    required this.time,
    required this.id,
  }) : super(key: key);

  @override
  State<ProductView> createState() => ProductViewState();
}

String name = "";

// ignore: camel_case_types
class ProductViewState extends State<ProductView> {
  TextEditingController amount = TextEditingController();

  Future<void> updateBid(double amount, double check, String _id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Product')
        .where('id', isEqualTo: _id)
        .limit(1)
        .get();

    String userEmail = querySnapshot.docs.first.get("userEmail");

    var vari = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    name = vari.docs.first.data()["name"];

    if (check > amount) {
      return;
    } else if (amount < check + 100) {
      return;
    }

    DocumentReference userDocRef = querySnapshot.docs[0].reference;

    userDocRef.update({
      'actualPrice': amount,
    });
  }

  Future<void> getName(String _id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Product')
        .where('id', isEqualTo: _id)
        .limit(1)
        .get();

    String userEmail = querySnapshot.docs.first.get("userEmail");

    var vari = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    name = vari.docs.first.data()["name"];
  }

  Future<Null> getRegresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getName(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          FutureBuilder(
            future: getName(widget.id),
            builder: (context, snapshot) {
              return RefreshIndicator(
                onRefresh: getRegresh,
                child: Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 53.0),
                        height: 500.0,
                        child: Image.network(widget.image)),
                    Positioned(
                      bottom: 0,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Card(
                                  margin: const EdgeInsets.all(11),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.title,
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  AssetImage('profile.jpg'),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(name,
                                                style: TextStyle(
                                                    fontFamily: 'Nunito')),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(widget.description,
                                            style: TextStyle(
                                                fontFamily: 'Nunito')),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Text(
                                              'Ends in: ',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      40, 175, 125, 1),
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Nunito'),
                                            ),
                                            RemainingTime(
                                                timestamp: widget.time),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Current Bid: ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Nunito'),
                                            ),
                                            Text(
                                              'PKR ${widget.actualPrice.toString()}/-',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontFamily: 'Nunito'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Base Price: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Nunito'),
                                            ),
                                            Text(
                                              widget.basePrice.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Nunito'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 130,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: TextFormField(
                                                    controller: amount,
                                                    decoration: const InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText: 'Bid Amount',
                                                        labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Nunito'))),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            const Text('Total Bids: ',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'Nunito')),
                                            const Text('10',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontFamily: 'Nunito'))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Center(
                                          child: Container(
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 52,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              80, 232, 176)),
                                                  onPressed: ((() {
                                                    if (double.parse(
                                                            amount.text) >
                                                        widget.actualPrice) {
                                                      updateBid(
                                                        double.parse(
                                                            amount.text),
                                                        widget.actualPrice,
                                                        widget.id,
                                                      );
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ProductView(
                                                              title: widget
                                                                  .title,
                                                              description: widget
                                                                  .description,
                                                              basePrice: widget
                                                                  .basePrice,
                                                              actualPrice:
                                                                  double.parse(
                                                                      amount
                                                                          .text),
                                                              category: widget
                                                                  .category,
                                                              sellerEmail: widget
                                                                  .sellerEmail,
                                                              seller:
                                                                  widget.seller,
                                                              image:
                                                                  widget.image,
                                                              time: widget.time,
                                                              id: widget.id),
                                                        ),
                                                      );
                                                    }
                                                  })),
                                                  child: const Text('PLACE BID',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          color: Colors.black87,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 10.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 52,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              232, 80, 80)),
                                                  onPressed: ((() {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeProducts(),
                                                      ),
                                                    );
                                                  })),
                                                  child: const Text('BACK',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          color: Colors.black87,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
