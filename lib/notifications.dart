import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mazdoor_pk/ServiceView.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'ServiceViewSeller.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  static Future<void> createNotification(
      String email, String data, String userType, String messageType) async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    Timestamp now = Timestamp.now();
    DateTime dateTime = now.toDate();
    CollectionReference mainCollectionRef =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot snapshot =
        await mainCollectionRef.where('email', isEqualTo: user?.email).get();

    String docID = snapshot.docs.first.id;
    DocumentReference docRef = mainCollectionRef.doc(docID);

    docRef.collection("notification").add({
      'data': data,
      'sender': email,
      'time': dateTime.toString(),
      'user': userType,
      'messageType': messageType,
    });
  }

  Future getData() async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    CollectionReference mainCollectionRef =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot snapshot =
        await mainCollectionRef.where('email', isEqualTo: user?.email).get();

    if (snapshot.docs.isNotEmpty) {
      String docID = snapshot.docs.first.id;

      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(docID)
          .collection("notification")
          .get();

      return snap.docs;
    }
  }

  Future<Null> getRegresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final docs = getData();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Notifications",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      fontFamily: 'Nunito'),
                ),
              ),
              FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: getData,
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            String stringTime =
                                snapshot.data[index]["time"].toString();
                            DateTime dateTime = DateTime.parse(stringTime);

                            String timeAgo =
                                timeago.format(dateTime, locale: 'en_short');

                            return GestureDetector(
                              onTap: () {
                                if (snapshot.data[index]["user"] == "Buyer" &&
                                    snapshot.data[index]["messageType"] ==
                                        "Service Started") {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ServiceView(
                                  //         serviceID: snapshot.data[index]["id"],
                                  //         title: snapshot.data[index]["title"],
                                  //         description: snapshot.data[index]
                                  //             ["description"],
                                  //         basePrice: snapshot.data[index]
                                  //             ["totalBill"],
                                  //         category: snapshot.data[index]
                                  //             ["category"],
                                  //         time: snapshot.data[index]["time"],
                                  //         sellerEmail: snapshot.data[index]
                                  //             ["buyerEmail"]),
                                  //   ),
                                  // );
                                } else if (snapshot.data[index]["user"] ==
                                        "Seller" &&
                                    snapshot.data[index]["messageType"] ==
                                        "Service Started") {}
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 240, 240, 240),
                                            )
                                          ]),
                                      child: Text.rich(
                                        style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w500,
                                            height: 1.8),
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "$timeAgo ago",
                                            ),
                                            TextSpan(
                                              text: "\n" +
                                                  snapshot.data[index]
                                                      ["sellerName"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: " - " +
                                                  snapshot.data[index]["data"],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
