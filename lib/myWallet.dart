import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homeProducts.dart';

class MyWalllet extends StatefulWidget {
  const MyWalllet({Key? key}) : super(key: key);

  @override
  State<MyWalllet> createState() => MyWallletState();
}

Future<void> addMoney(String _money) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? totalMoney = int.parse(_money);

  var vari = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: user?.email)
      .get();

  totalMoney = (totalMoney + vari.docs.first.data()["money"]) as int?;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .limit(1)
        .get();
    DocumentReference userDocRef = querySnapshot.docs[0].reference;
    userDocRef.update(
      {
        'money': totalMoney,
      },
    );
  } catch (error) {
    print('Error updating user data: $error');
  }
}

class MyWallletState extends State<MyWalllet> {
  TextEditingController _money = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 300, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: TextField(
                      controller: _money,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Add Money",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeProducts(),
                                ),
                              );
                            },
                            child: Text("Go Back"),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              print(_money.text);
                              addMoney(_money.text);
                            },
                            child: Text("Add Money"),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
