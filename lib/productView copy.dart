import 'package:flutter/material.dart';

// ignore: camel_case_types
class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => ProductViewState();
}

// ignore: camel_case_types
class ProductViewState extends State<ProductView> {
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
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('productImage.jpg'),
                      fit: BoxFit.fitHeight,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                          'Samsung Galaxy A20E SM-A202F/DS 32GB Black Mobile Smart Phone UNLOCKED',
                                          style: TextStyle(
                                              fontSize: 23,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w600)),
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
                                          Text('Vinesh Juriasinghani',
                                              style: TextStyle(
                                                  fontFamily: 'Nunito')),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                                          style:
                                              TextStyle(fontFamily: 'Nunito')),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: const [
                                          Text(
                                            'Ends in: ',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    40, 175, 125, 1),
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Nunito'),
                                          ),
                                          Text(
                                            '03hr 14m 12s',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    40, 175, 125, 1),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Nunito'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            'Current Bid: ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito'),
                                          ),
                                          Text(
                                            'PKR 8,500/-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Nunito'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            'Base Price: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito'),
                                          ),
                                          Text(
                                            'PKR 6000/-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Nunito'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: TextFormField(
                                                  decoration: const InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                      labelText: 'Bid Amount',
                                                      labelStyle: TextStyle(
                                                          fontFamily:
                                                              'Nunito'))),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          const Text('Total Bids: ',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: 'Nunito')),
                                          const Text('10',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: 'Nunito'))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 25,
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
                                                        Color.fromARGB(
                                                            255, 80, 232, 176)),
                                                onPressed: ((() {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ProductView()));
                                                })),
                                                child: const Text('PLACE BID',
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
