import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/homeProducts.dart';
import 'package:mazdoor_pk/profile.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => PersonalInfoState();
}

Future<void> updateUser(String _name, String _bio, String _job) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .limit(1)
        .get();
    DocumentReference userDocRef = querySnapshot.docs[0].reference;
    userDocRef.update({
      'name': _name,
      'bio': _bio,
      'job': _job,
    });
  } catch (error) {
    print('Error updating user data: $error');
  }
}

class PersonalInfoState extends State<PersonalInfoScreen> {
  late TextEditingController _name = TextEditingController();
  late TextEditingController _bio = TextEditingController();
  late TextEditingController _job = TextEditingController();

  String? name;
  String? bio;
  String? job;

  Future<void> getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();

    name = querySnapshot.docs.first.data()["name"];
    bio = querySnapshot.docs.first.data()["bio"];
    job = querySnapshot.docs.first.data()["job"];

    setState(() {
      _name = TextEditingController(text: name);
      _bio = TextEditingController(text: bio);
      _job = TextEditingController(text: job);
    });
  }

  @override
  Widget build(BuildContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        TextField(
                          controller: _name,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _bio,
                          maxLines: 6,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Bio",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _job,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Job",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 52,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 232, 80, 80)),
                                  onPressed: ((() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile()));
                                  })),
                                  child: const Text('    BACK    ',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 52,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 80, 232, 176)),
                                  onPressed: () {
                                    updateUser(
                                        _name.text, _bio.text, _job.text);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      ),
                                    );
                                  },
                                  child: const Text('    Save    ',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
