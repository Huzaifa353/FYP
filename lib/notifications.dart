import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mazdoor_pk/NotificationBox.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future getData() async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    CollectionReference mainCollectionRef =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot snapshot =
        await mainCollectionRef.where('email', isEqualTo: user?.email).get();

    if (snapshot.docs.length > 0) {
      String docID = snapshot.docs.first.id;

      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(docID)
          .collection("notification")
          .get();

      return snap.docs;
    }
  }

  Future<Null> getRefresh() async {
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
    final note = [
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
      "Electrician is on his way",
      "sent you an Offer on I want a plumber to repair my basin",
    ];
    var noteWriter = [
      "Ahmad Nazeer",
      "Muhammad Yasir",
      "Ahmad Nazeer",
      "Muhammad Yasir",
      "Ahmad Nazeer",
      "Muhammad Yasir",
      "Ahmad Nazeer",
      "Muhammad Yasir",
      "Ahmad Nazeer",
      "Muhammad Yasir",
      "Ahmad Nazeer",
      "Muhammad Yasir",
      "Ahmad Nazeer",
      "Muhammad Yasir",
      "Ahmad Nazeer",
      "Muhammad Yasir"
    ];
    var timings = [
      "21 minutes ago",
      "1 hour ago",
      "21 minutes ago",
      "1 hour ago",
      "21 minutes ago",
      "1 hour ago",
      "21 minutes ago",
      "1 hour ago",
      "21 minutes ago",
      "1 hour ago",
      "21 minutes ago",
      "1 hour ago",
      "21 minutes ago",
      "1 hour ago",
      "21 minutes ago",
      "1 hour ago"
    ];
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
                            return GestureDetector(
                                onTap: () {
                                  //createNotification();
                                },
                                child: NotificationBox(
                                    notification: snapshot.data[0]));
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
