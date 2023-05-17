// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mazdoor_pk/RemainingTime.dart';
import 'package:mazdoor_pk/chat.dart';
import 'package:mazdoor_pk/homeServices.dart';
import 'package:mazdoor_pk/rating.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:mazdoor_pk/CreateNotifications.dart';

// ignore: camel_case_types
class ServiceView extends StatefulWidget {
  final title;
  final description;
  final sellerEmail;
  final basePrice;
  final currentBid;
  final category;
  final seller;
  final image;
  final time;
  final serviceID;
  final emergency;

  const ServiceView({
    Key? key,
    required this.title,
    required this.sellerEmail,
    required this.description,
    required this.basePrice,
    required this.currentBid,
    required this.category,
    required this.seller,
    required this.image,
    required this.time,
    required this.serviceID,
    required this.emergency,
  }) : super(key: key);

  @override
  State<ServiceView> createState() => ServiceViewState();
}

// ignore: camel_case_types
class ServiceViewState extends State<ServiceView> {
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();
  late String name = 'loading...';
  late double rating = 0;
  late bool ownProduct = false;
  late String status = "running";
  late bool bidWon = false;

  // Service Orders
  late int orderCount = 0;
  bool enableButton = true;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  void initializeFirebase() {
    Firebase.initializeApp().then((value) {
      getData();
    });
  }

  Future<void> accept(String _id) async {
    CollectionReference subCollectionRef = FirebaseFirestore.instance
        .collection('Service')
        .doc(widget.serviceID)
        .collection('ServiceOrders');
    DocumentReference subDocRef = subCollectionRef.doc(_id);

    subDocRef.update({"status": "Accepted"});
    removeUnaccepted();
    endBid();
  }

  Future<void> reject(String _id) async {
    CollectionReference subCollectionRef = FirebaseFirestore.instance
        .collection('Service')
        .doc(widget.serviceID)
        .collection('ServiceOrders');
    DocumentReference subDocRef = subCollectionRef.doc(_id);

    // subDocRef.update({"status": "Rejected"});
    subDocRef.delete();
  }

  Future<void> removeUnaccepted() async {
    var collection = FirebaseFirestore.instance
        .collection('Service')
        .doc(widget.serviceID)
        .collection('ServiceOrders')
        .where('status', isNotEqualTo: 'Accepted');

    var snapshots = await collection.get();

    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future endBid() async {
    DocumentSnapshot<Map<String, dynamic>> serviceSnapshot =
        await FirebaseFirestore.instance
            .collection('Service')
            .doc(widget.serviceID)
            .get();
    DocumentReference serviceDocRef = serviceSnapshot.reference;

    serviceDocRef.update({
      'status': 'ended',
    });
  }

  Future<void> updateBid(double amount, String description) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Service')
        .where('id', isEqualTo: widget.serviceID)
        .limit(1)
        .get();

    final currentUser = FirebaseAuth.instance.currentUser;

    final subcollectionRef = FirebaseFirestore.instance
        .collection('Service')
        .doc(widget.serviceID)
        .collection('ServiceOrders');

    var nameOfBidder = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: currentUser?.email)
        .get();

    String currentName = nameOfBidder.docs.first.data()["name"];

    final DocumentReference documentRef = await subcollectionRef.add({
      'title': widget.title,
      'userEmail': currentUser?.email,
      'price': amount,
      'description': description,
      'id': widget.serviceID,
      'status': "Not Accepted",
      'name': currentName,
    });

    final String documentId = documentRef.id;

    await documentRef.update({'id': documentId});
  }

  Future getServiceOrders() async {
    DocumentSnapshot<Map<String, dynamic>> serviceSnapshot =
        await FirebaseFirestore.instance
            .collection('Service')
            .doc(widget.serviceID)
            .get();
    var orderRef =
        await serviceSnapshot.reference.collection('ServiceOrders').get();
    var serviceOrders = orderRef.docs;

    orderCount = serviceOrders.length;

    return serviceOrders;
  }

  Future getData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> serviceSnapshot =
          await FirebaseFirestore.instance
              .collection('Service')
              .doc(widget.serviceID)
              .get();

      FirebaseAuth auth = FirebaseAuth.instance;

      String userEmail = serviceSnapshot.data()?["userEmail"];
      status = serviceSnapshot.data()?["status"];
      String? bidUser = serviceSnapshot.data()?["bidUser"];
      if (bidUser != null) {
        bidWon = (status == 'ended' && bidUser == auth.currentUser!.email);
      }

      ownProduct = (auth.currentUser!.email == userEmail);

      var user = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      name = user.docs.first.data()["name"];
      rating = user.docs.first.data()["rating"].toDouble();

      return getServiceOrders();
    } catch (error) {
      print('Error fetching name: $error');
    }
  }

  Future<void> buttonCheck() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Service")
        .doc(widget.serviceID)
        .collection("ServiceOrders")
        .where("status", isEqualTo: "Accepted")
        .get();

    if (snapshot.docs.isNotEmpty) {
      enableButton = false;
    } else {
      enableButton = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Connection Error");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 171, 109),
                      ),
                    ),
                  );
                } else {
                  var orders = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 53.0),
                            child: Image.network(widget.image)),
                        SafeArea(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Center(
                                  child: Card(
                                      margin: const EdgeInsets.fromLTRB(
                                          11, 0, 11, 11),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 0, 18, 18),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.title,
                                                  style: const TextStyle(
                                                      fontSize: 23,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  const CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/profile.jpg'),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 11,
                                                      ),
                                                      Text(name,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                          )),
                                                      Rating(rating: rating),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              Text(widget.description,
                                                  style: const TextStyle(
                                                      fontFamily: 'Nunito')),
                                              const SizedBox(height: 10),
                                              widget.emergency
                                                  ? const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Text(
                                                        "Emergency!",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    230,
                                                                    212,
                                                                    37,
                                                                    37),
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Nunito',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    )
                                                  : Container(),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Ends in: ',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            40, 175, 125, 1),
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 17,
                                                        fontFamily: 'Nunito'),
                                                  ),
                                                  (status == 'running')
                                                      ? RemainingTime(
                                                          timestamp:
                                                              widget.time)
                                                      : const Text(
                                                          'The Bid has ended',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      230,
                                                                      212,
                                                                      37,
                                                                      37),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontFamily:
                                                                  'Nunito'))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Expected Price: ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Nunito'),
                                                  ),
                                                  Text(
                                                    'PKR ${widget.basePrice.toString()}/-',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Nunito'),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              bidWon
                                                  ? const Text(
                                                      'Congrats! You have Offer has been Accepted.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              40, 175, 125, 1),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: 'Nunito',
                                                          fontSize: 19))
                                                  : Container(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              (!ownProduct &&
                                                      status == "running")
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 130,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: TextFormField(
                                                                    controller:
                                                                        amount,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration: const InputDecoration(
                                                                        border:
                                                                            UnderlineInputBorder(),
                                                                        labelText:
                                                                            'Your Offer',
                                                                        labelStyle:
                                                                            TextStyle(fontFamily: 'Nunito'))),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 25,
                                                            ),
                                                            Text(
                                                                'Total Bids: $orderCount',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Nunito'))
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: TextFormField(
                                                              controller:
                                                                  description,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              maxLines: 4,
                                                              decoration: const InputDecoration(
                                                                  border:
                                                                      UnderlineInputBorder(),
                                                                  labelText:
                                                                      'Describe Your Offer',
                                                                  labelStyle: TextStyle(
                                                                      fontFamily:
                                                                          'Nunito'))),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              bidWon
                                                  ? SizedBox(
                                                      width: double.infinity,
                                                      height: 52,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      80,
                                                                      232,
                                                                      176)),
                                                          onPressed: ((() {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ChatMessaging(),
                                                              ),
                                                            );
                                                          })),
                                                          child: const Text(
                                                              'PROCEED TO PAYMENT',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                        ),
                                                      ),
                                                    )
                                                  : (status == 'running')
                                                      ? Center(
                                                          child: ownProduct
                                                              ? SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 52,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    child:
                                                                        TextButton(
                                                                      style: TextButton.styleFrom(
                                                                          backgroundColor: const Color.fromARGB(
                                                                              230,
                                                                              212,
                                                                              37,
                                                                              37)),
                                                                      onPressed:
                                                                          ((() {
                                                                        endBid();
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ServiceView(title: widget.title, description: widget.description, basePrice: widget.basePrice, currentBid: widget.currentBid, category: widget.category, sellerEmail: widget.sellerEmail, seller: widget.seller, image: widget.image, time: widget.time, serviceID: widget.serviceID, emergency: widget.emergency)));
                                                                      })),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: const [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 10.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.cancel_outlined,
                                                                              color: Color.fromRGBO(255, 255, 255, 0.9),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                              'END BID',
                                                                              style: TextStyle(fontFamily: 'Nunito', color: Color.fromRGBO(255, 255, 255, 0.9), fontSize: 18, fontWeight: FontWeight.w700)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : (status ==
                                                                      "running")
                                                                  ? SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          52,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        child:
                                                                            TextButton(
                                                                          style:
                                                                              TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 80, 232, 176)),
                                                                          onPressed:
                                                                              ((() {
                                                                            updateBid(double.parse(amount.text),
                                                                                description.text);
                                                                            Navigator.pop(context);
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => ServiceView(title: widget.title, description: widget.description, basePrice: widget.basePrice, currentBid: widget.currentBid, category: widget.category, sellerEmail: widget.sellerEmail, seller: widget.seller, image: widget.image, time: widget.time, serviceID: widget.serviceID, emergency: widget.emergency),
                                                                              ),
                                                                            );
                                                                          })),
                                                                          child: const Text(
                                                                              'PLACE BID',
                                                                              style: TextStyle(fontFamily: 'Nunito', color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                        )
                                                      : Container(),
                                              Center(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: 52,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: TextButton(
                                                        style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    233,
                                                                    233,
                                                                    233)),
                                                        onPressed: ((() {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomeServices(),
                                                            ),
                                                          );
                                                        })),
                                                        child: const Text(
                                                            'BACK',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Nunito',
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )))),
                            ])),
                        (ownProduct)
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: (orderCount > 0)
                                        ? const Text("OFFERS",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w800))
                                        : const Text("No Offers Yet",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w600)),
                                  ),
                                  ListView.builder(
                                    itemCount: orders.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Disable scrolling
                                    itemBuilder: (context, index) {
                                      var order = orders[index];
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              margin: const EdgeInsets.fromLTRB(
                                                  15, 0, 15, 30),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(21),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/profile.jpg'),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          order['name'],
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      order['description'],
                                                      style: const TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Offered: ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 15),
                                                        ),
                                                        Text(
                                                          "PKR " +
                                                              order['price']
                                                                  .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Nunito'),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    (order['status'] ==
                                                            "Accepted")
                                                        ? Column(
                                                            children: [
                                                              const Center(
                                                                child: Text(
                                                                  'Accepted',
                                                                  style: TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          40,
                                                                          175,
                                                                          125,
                                                                          1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontSize:
                                                                          17,
                                                                      fontFamily:
                                                                          'Nunito'),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ChatMessaging()));
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 21),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          11,
                                                                          119,
                                                                          207)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: const [
                                                                      Icon(
                                                                        Icons
                                                                            .message,
                                                                        size:
                                                                            33.0,
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0.9),
                                                                      ),
                                                                      Text(
                                                                          ' Message',
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(255, 255, 255, 0.9),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Nunito',
                                                                              fontSize: 17)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(
                                                            height: 52,
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ChatMessaging()));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 52,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        color: const Color.fromARGB(
                                                                            255,
                                                                            11,
                                                                            119,
                                                                            207)),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .message,
                                                                        size:
                                                                            33.0,
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0.9),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      FloatingActionButton(
                                                                    elevation:
                                                                        0.0,
                                                                    onPressed:
                                                                        () {
                                                                      reject(order[
                                                                          'id']);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => ServiceView(
                                                                              title: widget.title,
                                                                              description: widget.description,
                                                                              basePrice: widget.basePrice,
                                                                              currentBid: widget.currentBid,
                                                                              category: widget.category,
                                                                              sellerEmail: widget.sellerEmail,
                                                                              seller: widget.seller,
                                                                              image: widget.image,
                                                                              time: widget.time,
                                                                              serviceID: widget.serviceID,
                                                                              emergency: widget.emergency),
                                                                        ),
                                                                      );
                                                                    },
                                                                    backgroundColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            232,
                                                                            80,
                                                                            80),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child: const Text(
                                                                        'Reject',
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                0.9),
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontFamily:
                                                                                'Nunito',
                                                                            fontSize:
                                                                                17)),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      FloatingActionButton(
                                                                    elevation:
                                                                        0.0,
                                                                    onPressed:
                                                                        () {
                                                                      buttonCheck();
                                                                      if (enableButton ==
                                                                          true) {
                                                                        // CreateNotificationsExtra(
                                                                        //     widget
                                                                        //         .sellerEmail,
                                                                        //     "Service Started",
                                                                        //     "Buyer",
                                                                        //     "Service Started",
                                                                        //     widget
                                                                        //         .serviceID,
                                                                        //     widget
                                                                        //         .title,
                                                                        //     widget
                                                                        //         .category,
                                                                        //     widget
                                                                        //         .time,
                                                                        //     order[
                                                                        //         "userEmail"],
                                                                        //     order[
                                                                        //         "price"],
                                                                        //     order[
                                                                        //         "name"],
                                                                        //     name);

                                                                        accept(order[
                                                                            "id"]);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) => ServiceView(
                                                                                title: widget.title,
                                                                                description: widget.description,
                                                                                basePrice: widget.basePrice,
                                                                                currentBid: widget.currentBid,
                                                                                category: widget.category,
                                                                                sellerEmail: widget.sellerEmail,
                                                                                seller: widget.seller,
                                                                                image: widget.image,
                                                                                time: widget.time,
                                                                                serviceID: widget.serviceID,
                                                                                emergency: widget.emergency),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          const SnackBar(
                                                                            content:
                                                                                Text('Offer has already been accepted.'),
                                                                            duration:
                                                                                Duration(seconds: 5),
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                    backgroundColor:
                                                                        const Color.fromARGB(
                                                                            255,
                                                                            80,
                                                                            232,
                                                                            176),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child: const Text(
                                                                        'Accept',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black87,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontFamily:
                                                                                'Nunito',
                                                                            fontSize:
                                                                                17)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  );
                }
              }),
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
