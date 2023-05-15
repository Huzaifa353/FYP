import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazdoor_pk/login.dart';
import 'package:mazdoor_pk/productList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as logDev;
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyRegisterState createState() => _MyRegisterState();
}

class CreateUser {
  String? id;
  String name;
  String email;
  String password;
  // String cnic;
  //String phone;

  CreateUser({
    this.id,
    required this.name,
    required this.email,
    //required this.cnic,
    required this.password,
    //required this.phone
  });

  setUser(String name, String email, String password) {
    this.name = name;
    this.email = email;
    this.password = password;
    //this.phone = phone;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        //'phone': phone,
      };

  static CreateUser fromJson(Map<String, dynamic> json) => CreateUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password']);

  factory CreateUser.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return CreateUser(
      id: document.id,
      email: data["email"],
      password: data["password"],
      name: data["name"],
    );
  }
}

Future create_user(CreateUser user) async {
  final auth = FirebaseAuth.instance;

  try {
    final register = await auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
    //final docUser = FirebaseFirestore.instance.collection("users").doc("user1");
    final docUser = FirebaseFirestore.instance.collection("users").doc();
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  } on FirebaseAuthException catch (e) {
    print(e.toString());
    print("Error registering");
  }
}

print(final msg) {
  logDev.log(msg);
}

Future getUserData(String email) async {
  final snapshot = FirebaseFirestore.instance
      .collection("users")
      .where("email", isEqualTo: email)
      .get();

  print(snapshot);
}

class _MyRegisterState extends State<Register> {
  final controlName = TextEditingController();
  final controlId = TextEditingController();
  final controlEmail = TextEditingController();
  final controlPassword = TextEditingController();
  final controlPhone = TextEditingController();

  final ref = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('../assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: const Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: controlName,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Name",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: controlEmail,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: controlPassword,
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0x55000000),
                                child: IconButton(
                                    color: Colors.white,
                                    // onPressed: (() {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               ProductList()));
                                    // }),
                                    onPressed: (() {
                                      final createUser = CreateUser(
                                          name: controlName.text,
                                          email: controlEmail.text,
                                          password: controlPassword.text,
                                          id: "1");

                                      create_user(createUser);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()));
                                    }),
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: null,
                                style: const ButtonStyle(),
                                child: TextButton(
                                  onPressed: (() {
                                    final createUser = CreateUser(
                                        name: controlName.text,
                                        email: controlEmail.text,
                                        password: controlPassword.text,
                                        id: "1");

                                    create_user(createUser);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  }),
                                  child: const Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
