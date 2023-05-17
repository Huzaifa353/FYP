import 'package:flutter/material.dart';
import 'package:mazdoor_pk/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mazdoor_pk/createUserModel.dart';
import 'package:mazdoor_pk/homeServices.dart';
import 'package:mazdoor_pk/serviceView.dart';
import 'printing.dart' as pr;
import 'counterBid.dart';
import 'package:mazdoor_pk/note.dart' as note;

class ServiceViewSeller extends StatefulWidget {
  final id;
  final title;
  final price;
  final category;
  final time;
  final email;

  const ServiceViewSeller(
      {required this.id,
      required this.title,
      required this.price,
      required this.category,
      required this.time,
      required this.email});

  @override
  State<ServiceViewSeller> createState() => ServiceViewSellerState();
}

String name = "AAAA";
bool enableButton = true;
String acceptedId = "";

class ServiceViewSellerState extends State<ServiceViewSeller> {
  Future<void> accept(String _id) async {
    CollectionReference subCollectionRef = FirebaseFirestore.instance
        .collection('Service')
        .doc(widget.id)
        .collection('ServiceOrders');
    DocumentReference subDocRef = subCollectionRef.doc(_id);

    subDocRef.update({"status": "Accepted"});
    removeUnaccepted();
  }

  Future<void> reject(String _id) async {
    CollectionReference subCollectionRef = FirebaseFirestore.instance
        .collection('Service')
        .doc(widget.id)
        .collection('ServiceOrders');
    DocumentReference subDocRef = subCollectionRef.doc(_id);

    // subDocRef.update({"status": "Rejected"});
    subDocRef.delete();
  }

  Future<void> getName(String _id) async {
    pr.print("aaaaaa");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Service')
        .where('id', isEqualTo: _id)
        .limit(1)
        .get();

    String userEmail = querySnapshot.docs.first.get("userEmail");

    var vari = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();

    name = vari.docs.first.data()["name"];
    pr.print(name);
    buttonCheck();
  }

  Future<Null> getRegresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getName(widget.id);
      buttonCheck();
    });
  }

  // Future<void> createNotification(String email) async {
  //   pr.print("Started");
  //   final _auth = FirebaseAuth.instance;
  //   User? user = _auth.currentUser;

  //   Timestamp now = Timestamp.now();
  //   DateTime dateTime = now.toDate();
  //   CollectionReference mainCollectionRef =
  //       FirebaseFirestore.instance.collection('users');

  //   QuerySnapshot snapshot =
  //       await mainCollectionRef.where('email', isEqualTo: user?.email).get();

  //   String docID = snapshot.docs.first.id;
  //   DocumentReference docRef = mainCollectionRef.doc(docID);
  //   pr.print(docID);
  //   docRef.collection("notification").add({
  //     'data': "Service Started",
  //     'sender': '${user?.email}',
  //     'time': dateTime.toString(),
  //     'user': "Buyer"
  //   });

  //   QuerySnapshot snapshotSell =
  //       await mainCollectionRef.where('email', isEqualTo: email).get();

  //   String docIDSell = snapshotSell.docs.first.id;
  //   DocumentReference docRefSell = mainCollectionRef.doc(docIDSell);
  //   pr.print("Sell");
  //   pr.print(docIDSell);

  //   docRefSell.collection("notification").add({
  //     'data': "Contract Accepted Start Working",
  //     'sender': '${email}',
  //     'time': dateTime.toString(),
  //     'user': "Seller"
  //   });
  // }

  Future<void> endOffer(String _id) async {
    try {
      await FirebaseFirestore.instance.collection("Service").doc(_id).delete();
      pr.print("Document Succesfully deleted");
    } catch (e) {
      print('Error deleting document: $e');
    }

    pr.print("Deleted");
  }

  Future<void> buttonCheck() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Service")
        .doc(widget.id)
        .collection("ServiceOrders")
        .where("status", isEqualTo: "Accepted")
        .get();

    pr.print("checkingButton");

    if (snapshot.docs.length > 0) {
      enableButton = false;
    } else {
      enableButton = true;
    }

    pr.print(enableButton.toString());
  }

  Future<void> removeUnaccepted() async {
    pr.print("AAAAAAAAAAAAAAAAAA");
    var collection = FirebaseFirestore.instance
        .collection('Service')
        .doc(widget.id)
        .collection('ServiceOrders')
        .where('status', isNotEqualTo: 'Accepted');

    pr.print("BBBBBBBBBBBBBBBBBBBBBBB");

    var snapshots = await collection.get();

    pr.print("CCCCCCCCCCCCCCC");

    for (var doc in snapshots.docs) {
      pr.print(doc.reference.id);
      pr.print("DDDDDDDDDDDDDDDDDDDDD");
      await doc.reference.delete();
    }

    pr.print("EEEEEEEEEEEEEEEEEEEE");

    // final subcollectionRef = FirebaseFirestore.instance
    //     .collection('yourCollection')
    //     .doc('yourDocument')
    //     .collection('yourSubcollection');

    // final query = subcollectionRef.where('status', isNotEqualTo: 'Accepted');

    // final snapshot = await query.get();

    // final batch = FirebaseFirestore.instance.batch();

    // snapshot.docs.forEach((doc) {
    //   batch.delete(doc.reference);
    // });

    // await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    pr.print("AAAABBBCCCDDD");
    pr.print(widget.id);
    pr.print("AAAABBBCCCDDD");
    pr.print(widget.email);
    pr.print("AAAABBBCCCDDD");
    pr.print(widget.time);
    pr.print("AAAABBBCCCDDD");
    pr.print(widget.price);
    pr.print("AAAABBBCCCDDD");
    pr.print(widget.title);
    pr.print("AAAABBBCCCDDD");
    pr.print(widget.category);

    bool isButtonEnabled = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
              child: FutureBuilder(
            future: getName(widget.id),
            builder: (context, snapshot) {
              return RefreshIndicator(
                onRefresh: getRegresh,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/UK_BS1363_double_wall_socket.jpg/800px-UK_BS1363_double_wall_socket.jpg'),
                          fit: BoxFit.fitWidth,
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
                                    const SizedBox(height: 20),
                                    const Text(
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.',
                                        style: TextStyle(fontFamily: 'Nunito')),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Text(
                                          'Ends in: ',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  40, 175, 125, 1),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                              fontFamily: 'Nunito'),
                                        ),
                                        Text(
                                          widget.time,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  40, 175, 125, 1),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17,
                                              fontFamily: 'Nunito'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Current Bid: ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Nunito'),
                                        ),
                                        Text(
                                          'PKR ${widget.price}/-',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontFamily: 'Nunito'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const SizedBox(
                                      height: 10,
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
                                                buttonCheck();
                                                if (enableButton == true) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          updateBid(
                                                        currentBidAmount:
                                                            widget.price,
                                                        id: widget.id,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  pr.print(
                                                      "Button is not Enabled");

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Offer has already been accepted.'),
                                                      duration:
                                                          Duration(seconds: 5),
                                                    ),
                                                  );
                                                }
                                              })),
                                              child: const Text('UPDATE BID',
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
                                    const SizedBox(
                                      height: 10,
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
                                                buttonCheck();
                                                if (enableButton == true) {
                                                  endOffer(widget.id);

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomeServices()));
                                                } else {
                                                  pr.print(
                                                      "Button is not Enabled");

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Offer has already been accepted.'),
                                                      duration:
                                                          Duration(seconds: 5),
                                                    ),
                                                  );
                                                }
                                              })),
                                              child: const Text('END OFFER',
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
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Service")
                                .doc(widget.id)
                                .collection("ServiceOrders")
                                .snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Connection Error");
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading...");
                              }

                              var docs = snapshot.data?.docs;

                              return ListView.builder(
                                itemCount: docs?.length,
                                shrinkWrap: true,
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
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          AssetImage(
                                                              'profile.jpg'),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      docs![index]["name"],
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
                                                  children: [
                                                    Text(
                                                      'Offered: ',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Nunito',
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "PKR " +
                                                          "${docs[index]["price"]}" +
                                                          "/-",
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
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ChatMessaging()));
                                                        },
                                                        child: Container(
                                                          width: 52,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  11,
                                                                  119,
                                                                  207)),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.message,
                                                              size: 33.0,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      0.9),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 52,
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        // padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                                        // width: MediaQuery.of(context).size.width / 2.25,
                                                        child:
                                                            FloatingActionButton(
                                                          elevation: 0.0,
                                                          onPressed: () {
                                                            buttonCheck();
                                                            if (enableButton ==
                                                                true) {
                                                              reject(docs[index]
                                                                  ["id"]);
                                                            } else {
                                                              pr.print(
                                                                  "Button is Disabled");
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'Offer has already been accepted.'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              5),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Reject',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          0.9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize:
                                                                      17)),
                                                          backgroundColor:
                                                              Colors.red,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        // padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                                        // width: MediaQuery.of(context).size.width / 2.25,
                                                        child:
                                                            FloatingActionButton(
                                                          elevation: 0.0,
                                                          onPressed: () {
                                                            buttonCheck();
                                                            pr.print(
                                                                "Button is: ");
                                                            pr.print(enableButton
                                                                .toString());
                                                            if (enableButton ==
                                                                true) {
                                                              pr.print(
                                                                  "Accepting the BID");
                                                              // createNotification(
                                                              //     docs![index][
                                                              //         "userEmail"]);

                                                              // Future<void> obj =
                                                              //     note.createNotification(
                                                              //         docs[index]
                                                              //             [
                                                              //             "userEmail"],
                                                              //         "Service Started",
                                                              //         "Buyer",
                                                              //         "Service Started");

                                                              pr.print(
                                                                  widget.email);

                                                              note.CreateNotificationsExtra(
                                                                  widget.email,
                                                                  "Service Started",
                                                                  "Buyer",
                                                                  "Service Started",
                                                                  widget.id,
                                                                  widget.title,
                                                                  widget
                                                                      .category,
                                                                  widget.time,
                                                                  docs[index][
                                                                      "userEmail"],
                                                                  docs[index]
                                                                      ["price"],
                                                                  docs[index]
                                                                      ["name"],
                                                                  name);

                                                              note.CreateNotificationsExtra(
                                                                  docs[index][
                                                                      "userEmail"],
                                                                  "Service Started",
                                                                  "Seller",
                                                                  "Service Started",
                                                                  widget.id,
                                                                  widget.title,
                                                                  widget
                                                                      .category,
                                                                  widget.time,
                                                                  widget.email,
                                                                  docs[index]
                                                                      ["price"],
                                                                  docs[index]
                                                                      ["name"],
                                                                  name);

                                                              pr.print(
                                                                  "Something is wrong");

                                                              accept(docs[index]
                                                                  ["id"]);
                                                            } else {
                                                              pr.print(
                                                                  "Button Disabled");
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                      'Offer has already been accepted.'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              5),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Accept',
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          0.9),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize:
                                                                      17)),
                                                          backgroundColor:
                                                              Colors.green,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
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
                              );
                            }),
                          ),
                        ])),
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
