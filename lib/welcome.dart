import 'package:flutter/material.dart';
import 'package:mazdoor_pk/info1.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: EdgeInsets.all(20)),
              Flexible(flex: 1, child: Image.asset('assets/WelcomeBG.jpg')),
              Padding(padding: EdgeInsets.all(20)),
              Row(children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
                  child: const Text(
                    "Welcome to \nMazdoor.pk",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito'),
                  ),
                ),
              ]),
              Row(children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
                  child: const Text("Quality Service at your Price",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito')),
                ),
              ]),
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
                            MaterialPageRoute(builder: (context) => Info1()));
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
