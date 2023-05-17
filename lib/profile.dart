import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/login.dart';
import 'package:mazdoor_pk/myWallet.dart';
import 'package:mazdoor_pk/rating.dart';
import 'package:mazdoor_pk/personalInformation.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

String? getUserEmail() {
  return user?.email;
}

String? getUserId() {
  return user?.uid;
}

// ignore: camel_case_types
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => ProfileState();
}

// ignore: camel_case_types
class ProfileState extends State<Profile> {
  late String name = "";
  late String bio = "";
  late String job = "loading...";
  late double money = 0;
  late double rating = 4.5;

  Future<void> getData() async {
    var vari = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();

    setState(() {
      name = vari.docs.first.data()['name'];
      bio = vari.docs.first.data()['bio'];
      job = vari.docs.first.data()['job'];
      money = vari.docs.first.data()['money'];
      rating = vari.docs.first.data()['rating'];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  return SafeArea(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              left: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      const AssetImage('assets/profile.jpg'),
                                  radius:
                                      MediaQuery.of(context).size.width * 0.14,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04 +
                                              10,
                                          fontFamily: 'Nunito'),
                                    ),
                                    Text(
                                      job,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02 +
                                              10,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Nunito'),
                                    ),
                                    Rating(
                                        key: ValueKey<double>(rating),
                                        rating: rating),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(bio,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            height: 30,
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('Rs. $money',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w800)),
                                  const Text(
                                    'Current Balance',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.07),
                            child: Container(
                              height: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PersonalInfoScreen(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.person,
                                            )),
                                        Text(
                                          'Personal Information',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyWalllet(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.account_balance_wallet,
                                            )),
                                        Text(
                                          'My Wallet',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.history,
                                            )),
                                        Text(
                                          'Transaction History',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.history_edu,
                                            )),
                                        Text(
                                          'Previous Orders',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.groups,
                                            )),
                                        Text(
                                          'Tell your Friends',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.settings,
                                            )),
                                        Text(
                                          'Settings',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()));
                                    },
                                    child: Row(
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.power_settings_new_sharp,
                                              color: Colors.red,
                                            )),
                                        Text(
                                          'Log out',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                })));
  }
}
