// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/AddProduct.dart';
import 'package:mazdoor_pk/RemainingTime.dart';
import 'package:mazdoor_pk/productView.dart';

class WinBids extends StatefulWidget {
  @override
  State<WinBids> createState() => WinBidsState();
}

class WinBidsState extends State<WinBids> {
  Future getProducts() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Product")
        .where("userEmail", isEqualTo: auth.currentUser!.email)
        .get();

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: const Text(
                    "Your Won Bids",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        fontFamily: 'Nunito'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getProducts(),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      shrinkWrap: true,
                      itemCount: snapshots.data.length,
                      itemBuilder: ((context, index) {
                        var snapshot = snapshots.data[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                child: Text(snapshot['title'],
                                    style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: Text("Category: " + snapshot['category'],
                                    style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black45)),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                child: Text(
                                    "Base Price PKR " +
                                        snapshot['basePrice'].toString() +
                                        "/-",
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87)),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: Text(
                                    "Highest Bid PKR " +
                                        snapshot['currentBid'].toString() +
                                        "/-",
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                child: Row(
                                  children: [
                                    const Text("Bid ends in ",
                                        style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    (snapshot['status'] == "ended" ||
                                            snapshot['status'] == "paid")
                                        ? const Text('The Bid has ended',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    230, 212, 37, 37),
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Nunito'))
                                        : RemainingTime(
                                            timestamp: snapshot['time']),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 95,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 5),
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 80, 232, 176)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductView(
                                                title: snapshot['title'],
                                                description:
                                                    snapshot['description'],
                                                basePrice: snapshot['basePrice']
                                                    .toDouble(),
                                                currentBid:
                                                    snapshot['currentBid']
                                                        .toDouble(),
                                                category: snapshot['category'],
                                                sellerEmail:
                                                    snapshot['userEmail'],
                                                seller: snapshot['user'],
                                                image: snapshot['image'],
                                                time: snapshot['time'],
                                                productID: snapshot.id)));
                                  },
                                  child: const Text('VIEW',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Nunito',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  }
                }),
          ),
        ],
      )),
    );
  }
}
