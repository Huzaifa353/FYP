import 'package:flutter/material.dart';
import 'package:mazdoor_pk/serviceViewSeller.dart';
import 'package:mazdoor_pk/addService.dart';

class ServicesPosted extends StatefulWidget {
  @override
  State<ServicesPosted> createState() => ServicesPostedState();
}

class ServicesPostedState extends State<ServicesPosted> {
  @override
  Widget build(BuildContext context) {
    var currentServices = ['1', '2', '3'];
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
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
                  Row(
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
                        padding: EdgeInsets.only(top: 10.0),
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
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 23),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: ((context, index) {
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
                            child: const Text(
                                "I need an Electrician to replace 5 sockets at my Home.",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: const Text("Category: Electrician",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black45)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: const Text("Expected Price PKR 85,000/-",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                            child: const Text("Bid ends in 03hr 14m 12s",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                            child: const Text("Total Offers: 11",
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                          ),
                          Container(
                            width: double.infinity,
                            height: 95,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 80, 232, 176)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceViewSeller()));
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
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
