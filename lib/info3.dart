import 'package:flutter/material.dart';
import 'package:mazdoor_pk/login.dart';

class Info3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  color: Color.fromRGBO(34, 205, 142, 0.72),
                  child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Image.network('../assets/done.png'))),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: const Text(
                  "Get your work done",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito'),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
                child: const Text(
                    "Place the order and get your work done. \nComplete the order when the work is done",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                        height: 2)),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FloatingActionButton(
                      backgroundColor: Color.fromRGBO(34, 205, 142, 1.0),
                      onPressed: (() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      }),
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
