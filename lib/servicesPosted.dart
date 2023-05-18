// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/RemainingTime.dart';
import 'package:mazdoor_pk/ServiceView.dart';
import 'package:mazdoor_pk/addService.dart';

class ServicesPosted extends StatefulWidget {
  @override
  State<ServicesPosted> createState() => ServicesPostedState();
}

class ServicesPostedState extends State<ServicesPosted> {
  Future getServices() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Service")
        .where("userEmail", isEqualTo: auth.currentUser!.email)
        .get();

    return snapshot.docs;
  }

  Future getServiceOrders(snapshot) async {
    var orderRef = await snapshot.reference.collection('ServiceOrders').get();
    var serviceOrders = orderRef.docs;

    return serviceOrders;
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
                    "Your Services",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        fontFamily: 'Nunito'),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, right: 10.0),
                        child: Text('Need a Service?',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        width: 180,
                        height: 53,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(21),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(200, 230, 230, 230),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddService()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Post a Problem',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getServices(),
                builder: (context, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 23),
                      shrinkWrap: true,
                      itemCount: snapshots.data.length,
                      itemBuilder: ((context, index) {
                        var snapshot = snapshots.data[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
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
                                padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: Text(
                                    "Expected Price PKR ${snapshot['basePrice']}/-",
                                    style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
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
                                    (snapshot['status'] == "ended")
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
                              FutureBuilder(
                                  future: getServiceOrders(snapshot),
                                  builder: (context, orders) {
                                    var orderCount = orders.data?.length ?? 0;
                                    return Container(
                                      alignment: Alignment.topLeft,
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                      child: Text(
                                          "Total Offers: " +
                                              orderCount.toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87)),
                                    );
                                  }),
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
                                            builder: (context) => ServiceView(
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
                                                serviceID: snapshot.id,
                                                emergency:
                                                    snapshot['emergency'])));
                                  },
                                  child: const Text('VIEW OFFERS',
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
