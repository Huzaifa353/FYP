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
                                                      : SizedBox(
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
                                                                          255,
                                                                          80,
                                                                          232,
                                                                          176)),
                                                              onPressed: ((() {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => ServiceView(
                                                                        title: widget
                                                                            .title,
                                                                        description: widget
                                                                            .description,
                                                                        basePrice: widget
                                                                            .basePrice,
                                                                        currentBid:
                                                                            widget
                                                                                .currentBid,
                                                                        category:
                                                                            widget
                                                                                .category,
                                                                        sellerEmail:
                                                                            widget
                                                                                .sellerEmail,
                                                                        seller: widget
                                                                            .seller,
                                                                        image: widget
                                                                            .image,
                                                                        time: widget
                                                                            .time,
                                                                        serviceID:
                                                                            widget
                                                                                .serviceID,
                                                                        emergency:
                                                                            widget.emergency),
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
                                                                          FontWeight
                                                                              .w700)),
                                                            ),
                                                          ),
                                                        ),
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
