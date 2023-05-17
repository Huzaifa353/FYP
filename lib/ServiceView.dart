import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/RemainingTime.dart';
import 'package:mazdoor_pk/chat.dart';
import 'package:mazdoor_pk/homeServices.dart';
import 'package:mazdoor_pk/rating.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';

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
  late String name = 'loading...';
  late double rating = 0;
  late bool ownProduct = false;
  late String serviceID;
  late String status = "running";
  late bool bidWon = false;

  // Service Orders
  late int orderCount = 0;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  void initializeFirebase() {
    Firebase.initializeApp().then((value) {
      serviceID = widget.serviceID;
      getData();
    });
  }

  Future endBid() async {
    DocumentSnapshot<Map<String, dynamic>> serviceSnapshot =
        await FirebaseFirestore.instance
            .collection('Service')
            .doc(serviceID)
            .get();
    DocumentReference serviceDocRef = serviceSnapshot.reference;

    serviceDocRef.update({
      'status': 'ended',
    });
  }

  Future<void> updateBid(double amount) async {
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
      'id': widget.serviceID,
      'status': "Not Accepted",
      'name': currentName,
    });

    final String documentId = documentRef.id;

    await documentRef.update({'id': documentId});
  }

  Future getServiceOrders(snapshot) async {
    var orderRef = await snapshot.reference.collection('ServiceOrders').get();
    var serviceOrders = orderRef.docs;

    setState(() {
      orderCount = serviceOrders.length;
    });
  }

  Future<void> getData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> serviceSnapshot =
          await FirebaseFirestore.instance
              .collection('Service')
              .doc(serviceID)
              .get();

      getServiceOrders(serviceSnapshot);

      String userEmail = serviceSnapshot.data()?["userEmail"];
      String serviceStatus = serviceSnapshot.data()?["status"];
      String? bidUser = serviceSnapshot.data()?["bidUser"];

      FirebaseAuth auth = FirebaseAuth.instance;

      bool owner = (auth.currentUser!.email == userEmail);

      var user = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      setState(() {
        name = user.docs.first.data()["name"];
        rating = user.docs.first.data()["rating"].toDouble();
        ownProduct = owner;
        status = serviceStatus;
        if (bidUser != null) {
          bidWon = (status == 'ended' && bidUser == auth.currentUser!.email);
        }
      });
    } catch (error) {
      print('Error fetching name: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
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
                              margin: const EdgeInsets.fromLTRB(11, 0, 11, 11),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.title,
                                          style: const TextStyle(
                                              fontSize: 23,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w600)),
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
                                                  style: const TextStyle(
                                                    fontFamily: 'Nunito',
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
                                              padding:
                                                  EdgeInsets.only(top: 10.0),
                                              child: Text(
                                                "Emergency!",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        230, 212, 37, 37),
                                                    fontSize: 16,
                                                    fontFamily: 'Nunito',
                                                    fontWeight:
                                                        FontWeight.w800),
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
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                                fontFamily: 'Nunito'),
                                          ),
                                          FutureBuilder(
                                            future: getData(),
                                            builder: (context, snapshot) =>
                                                (status ==
                                                        'running')
                                                    ? RemainingTime(
                                                        timestamp: widget.time)
                                                    : const Text(
                                                        'The Bid has ended',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    230,
                                                                    212,
                                                                    37,
                                                                    37),
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontFamily:
                                                                'Nunito')),
                                          ),
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
                                                fontWeight: FontWeight.bold,
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
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      40, 175, 125, 1),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Nunito',
                                                  fontSize: 19))
                                          : Container(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      (!ownProduct && status == "running")
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  width: 130,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: TextFormField(
                                                        controller: amount,
                                                        decoration: const InputDecoration(
                                                            border:
                                                                UnderlineInputBorder(),
                                                            labelText:
                                                                'Bid Amount',
                                                            labelStyle: TextStyle(
                                                                fontFamily:
                                                                    'Nunito'))),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Text('Total Bids: $orderCount',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Nunito'))
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
                                                    BorderRadius.circular(15),
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              80,
                                                              232,
                                                              176)),
                                                  onPressed: ((() {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatMessaging(),
                                                      ),
                                                    );
                                                  })),
                                                  child: const Text(
                                                      'PROCEED TO PAYMENT',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          color: Colors.black87,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ),
                                            )
                                          : (status == 'running')
                                              ? Center(
                                                  child: ownProduct
                                                      ? SizedBox(
                                                          width:
                                                              double.infinity,
                                                          height: 52,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            child: TextButton(
                                                              style: TextButton.styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromARGB(
                                                                          230,
                                                                          212,
                                                                          37,
                                                                          37)),
                                                              onPressed: ((() {
                                                                endBid();
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => ServiceView(
                                                                            title:
                                                                                widget.title,
                                                                            description: widget.description,
                                                                            basePrice: widget.basePrice,
                                                                            currentBid: widget.currentBid,
                                                                            category: widget.category,
                                                                            sellerEmail: widget.sellerEmail,
                                                                            seller: widget.seller,
                                                                            image: widget.image,
                                                                            time: widget.time,
                                                                            serviceID: widget.serviceID,
                                                                            emergency: widget.emergency)));
                                                              })),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        right:
                                                                            10.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .cancel_outlined,
                                                                      color: Color.fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          0.9),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      'END BID',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color: Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              0.9),
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w700)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : (status == "running")
                                                          ? SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 52,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                child:
                                                                    TextButton(
                                                                  style: TextButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          80,
                                                                          232,
                                                                          176)),
                                                                  onPressed:
                                                                      ((() {
                                                                    updateBid(double
                                                                        .parse(amount
                                                                            .text));
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => ServiceView(
                                                                            title:
                                                                                widget.title,
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
                                                                  })),
                                                                  child: const Text(
                                                                      'PLACE BID',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          color: Colors
                                                                              .black87,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w700)),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                )
                                              : Container(),
                                      Center(
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
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
                                                          const HomeServices(),
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
                                  )))),
                    ])),
                (status == "running" && ownProduct)
                    ? ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Card(
                                  margin: const EdgeInsets.all(11),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 15),
                                        Row(
                                          children: const [
                                            CircleAvatar(
                                              backgroundImage:
                                                  AssetImage('profile.jpg'),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "James Wood",
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 15),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                              'Offered: ',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              "PKR 13,000/-",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontFamily: 'Nunito'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Container(
                                          height: 52,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
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
                                                child: Container(
                                                  width: 52,
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              11,
                                                              119,
                                                              207)),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.message,
                                                      size: 33.0,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.9),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: FloatingActionButton(
                                                  elevation: 0.0,
                                                  onPressed: () {},
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 233, 233, 233),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: const Text(
                                                    'Counter Offer',
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Nunito',
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 52,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: FloatingActionButton(
                                                  elevation: 0.0,
                                                  onPressed: () {},
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: const Text('Reject',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.9),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Nunito',
                                                          fontSize: 17)),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: FloatingActionButton(
                                                  elevation: 0.0,
                                                  onPressed: () {},
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: const Text('Accept',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.9),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Nunito',
                                                          fontSize: 17)),
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
                      )
                    : Container(),
              ],
            ),
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
