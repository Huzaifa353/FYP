// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/RemainingTime.dart';
import 'package:mazdoor_pk/serviceView.dart';

class ServiceList extends StatefulWidget {
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  Future getServices() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Service")
        //.where("status", isEqualTo: "running")
        .get();
    return snapshot.docs;
  }

  Future<Null> getRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      getServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
            future: getServices(),
            builder: (context, services) {
              if (services.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: getRefresh,
                  color: const Color.fromARGB(255, 0, 171, 109),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Services',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  fontFamily: 'Nunito'),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search_outlined))
                          ],
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double width = constraints.maxWidth;

                          double aspectRatio = (width - 120) / 300;
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 7,
                                      crossAxisSpacing: 0,
                                      childAspectRatio: aspectRatio),
                              itemCount: services.data.length,
                              itemBuilder: (context, index) {
                                var service = services.data[index];
                                return LayoutBuilder(builder:
                                    (BuildContext context,
                                        BoxConstraints constraints) {
                                  return Container(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 21),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.maxFinite,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 0,
                                                  blurRadius: 12,
                                                  offset: const Offset(0,
                                                      4), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                    child: Image.network(
                                                        service['image'],
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 180,
                                                        fit: BoxFit.cover),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 17),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(service['title'],
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    3,
                                                                    0,
                                                                    10),
                                                            child: Text(
                                                                "Category: " +
                                                                    service[
                                                                        'category'],
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black54)),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "PKR " +
                                                                    service['basePrice']
                                                                        .toString() +
                                                                    "/-",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              ),
                                                              const Text(
                                                                r' Expected Price',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black45,
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    10,
                                                                    0,
                                                                    0),
                                                            child: RemainingTime(
                                                                timestamp:
                                                                    service[
                                                                        'time']),
                                                          ),
                                                          service['emergency']
                                                              ? const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 10.0),
                                                                  child: Text(
                                                                    "Emergency!",
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            230,
                                                                            212,
                                                                            37,
                                                                            37),
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ]),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 0, 15, 20),
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 45,
                                                        child: TextButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      const Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          232,
                                                                          176)),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(15)))),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const ServiceView()));
                                                          },
                                                          child: const Text(
                                                              'OFFER',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
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
                                });
                              });
                        }),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}
