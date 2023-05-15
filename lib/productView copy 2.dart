import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/homeProducts.dart';

// ignore: camel_case_types
class ProductView extends StatefulWidget {
  String productID;

  ProductView({Key? key, required this.productID}) : super(key: key);

  @override
  State<ProductView> createState() => ProductViewState();
}

class ProductViewState extends State<ProductView> {
  TextEditingController amount = TextEditingController();
  String name = "";

  Future<Map<String, dynamic>?>? product;

  @override
  void initState() {
    super.initState();
    setState(() {
      product = getProduct(widget.productID);
    });
  }

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
      'currentBid': amount,
    });
  }

  Future<Map<String, dynamic>?> getProduct(String _id) async {
    final productDoc =
        await FirebaseFirestore.instance.collection('Products').doc(_id).get();

    return productDoc.data();
  }

  Future<void> getName(String _id) async {
    final productDoc =
        await FirebaseFirestore.instance.collection('Products').doc(_id).get();

    String userEmail = productDoc["userEmail"];

    var vari = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    name = vari.docs.first.data()["name"];
  }

  Future<Null> getRefresh() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      getName(widget.productID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
              child: FutureBuilder(
            future: getName(widget.productID),
            builder: (context, snashot) {
              return RefreshIndicator(
                onRefresh: getRefresh,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('productImage.jpg'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: null,
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Card(
                              margin: const EdgeInsets.all(11),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['title'],
                                        style: const TextStyle(
                                            fontSize: 23,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundImage:
                                              AssetImage('profile.jpg'),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(name,
                                            style: const TextStyle(
                                                fontFamily: 'Nunito')),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(product['description'],
                                        style: const TextStyle(
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
                                        Text(
                                          product['time'],
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  40, 175, 125, 1),
                                              fontWeight: FontWeight.w700,
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
                                          'Current Bid: ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Nunito'),
                                        ),
                                        Text(
                                          'PKR ${product['currentBid'].toString()}/-',
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
                                          product['basePrice'].toString(),
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
                                                        fontFamily: 'Nunito'))),
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
                                                      const Color.fromARGB(
                                                          255, 80, 232, 176)),
                                              onPressed: ((() {
                                                if (double.parse(amount.text) >
                                                    product['currentBid']) {
                                                  updateBid(
                                                    double.parse(amount.text),
                                                    product['currentBid'],
                                                    widget.productID,
                                                  );
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductView(
                                                              productID: widget
                                                                  .productID),
                                                    ),
                                                  );
                                                } else {
                                                  const Text(
                                                      "Enter Valid Price");
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
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 52,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 232, 80, 80)),
                                              onPressed: ((() {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeProducts(),
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
                  ],
                ),
              );
            },
          )),
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
