// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:mazdoor_pk/login.dart';

// ignore: camel_case_types
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => ProfileState();
}

// ignore: camel_case_types
class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: const AssetImage('profile.jpg'),
                            radius: MediaQuery.of(context).size.width * 0.14,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Huzaifa Shamoon',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                                0.04 +
                                            10,
                                    fontFamily: 'Nunito'),
                              ),
                              Text(
                                'Electrician',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                                0.02 +
                                            10,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Nunito'),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                          'This is Bio of the user. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: TextStyle(
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
                          children: const [
                            Text('PKR 104,580.00',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800)),
                            Text(
                              'Current Balance',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        Column(
                          children: const [
                            Text('PKR 84,720.00',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800)),
                            Text(
                              'Pending Clearance',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        )
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
                          horizontal: MediaQuery.of(context).size.width * 0.07),
                      child: Container(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {},
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
                              onTap: () {},
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
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
            ))));
  }
}