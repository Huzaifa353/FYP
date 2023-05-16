import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/productView.dart';
import 'package:mazdoor_pk/RemainingTime.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future getProducts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Product")
        .where("status", isEqualTo: "running")
        .get();
    return snapshot.docs;
  }

  Future<Null> getRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
            future: getProducts(),
            builder: (context, products) {
              if (products.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: getRefresh,
                  backgroundColor: Colors.green,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Recent Items',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                    fontFamily: 'Nunito'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            double width = constraints.maxWidth;

                            double aspectRatio = (width - 100) / 600;
                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 7,
                                        crossAxisSpacing: 0,
                                        childAspectRatio: aspectRatio),
                                itemCount: products.data.length,
                                itemBuilder: (context, index) {
                                  var product = products.data[index];
                                  return LayoutBuilder(builder:
                                      (BuildContext context,
                                          BoxConstraints constraints) {
                                    return Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight,
                                      margin: const EdgeInsets.all(15),
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
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                        child: Image.network(
                                                            product['image'],
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 120,
                                                            fit: BoxFit
                                                                .contain)),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Column(children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 10),
                                                            child: Text(
                                                                product[
                                                                    'title'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700))),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      0.0),
                                                          child:
                                                              product['currentBid'] <=
                                                                      0
                                                                  ? const Text(
                                                                      'No bids yet',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black45,
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                      ),
                                                                    )
                                                                  : Wrap(
                                                                      runSpacing:
                                                                          1.0,
                                                                      spacing:
                                                                          1.0,
                                                                      children: [
                                                                        Text(
                                                                          '${r'PKR ' + product['currentBid'].toString()}/-',
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              fontFamily: 'Nunito',
                                                                              fontWeight: FontWeight.w800),
                                                                        ),
                                                                        const Text(
                                                                          r' Current Bid',
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              color: Colors.black45,
                                                                              fontFamily: 'Nunito',
                                                                              fontWeight: FontWeight.w800),
                                                                        )
                                                                      ],
                                                                    ),
                                                        ),
                                                        Wrap(
                                                          runSpacing: 1.0,
                                                          spacing: 1.0,
                                                          children: [
                                                            Text(
                                                              '${r'PKR ' + product['basePrice'].toString()}/-',
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            ),
                                                            const Text(
                                                              r' Base Price',
                                                              style: TextStyle(
                                                                  fontSize: 11,
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
                                                                    product[
                                                                        'time'])),
                                                      ]),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 0, 15, 15),
                                                      child: Center(
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
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
                                                                      builder: (context) => ProductView(
                                                                          title: product[
                                                                              'title'],
                                                                          description: product[
                                                                              'description'],
                                                                          basePrice: product['basePrice']
                                                                              .toDouble(),
                                                                          currentBid: product['currentBid']
                                                                              .toDouble(),
                                                                          category: product[
                                                                              'category'],
                                                                          sellerEmail: product[
                                                                              'userEmail'],
                                                                          seller: product[
                                                                              'user'],
                                                                          image: product[
                                                                              'image'],
                                                                          time: product[
                                                                              'time'],
                                                                          productID:
                                                                              product.id)));
                                                            },
                                                            child: const Text(
                                                                'PLACE BID',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontSize:
                                                                        16,
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
                  ),
                );
              }
            }),
      ),
    );
  }
}
