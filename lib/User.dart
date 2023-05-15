import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfo {
  String? id;
  String name;
  String email;
  String password;
  String bio;
  String job;
  int money;
  // String cnic;
  //String phone;

  UserInfo({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.money,
    required this.bio,
    required this.job,
  });

  setUser(String name, String email, String password) {
    this.name = name;
    this.email = email;
    this.password = password;
    this.bio = "N\A";
    this.money = 0;
    this.job = "N\A";
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'bio': bio,
        'money': money,
        'job': job,
      };

  static UserInfo fromJson(Map<String, dynamic> json) => UserInfo(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        money: json['money'],
        bio: json['bio'],
        job: json['job'],
      );

  factory UserInfo.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return UserInfo(
      id: document.id,
      email: data["email"],
      password: data["password"],
      name: data["name"],
      money: data["money"],
      bio: data["bio"],
      job: data["job"],
    );
  }

  void set_user_name(String name) {
    this.name = name;
  }

  void set_user_password(String password) {
    this.password = password;
  }

  String? get_user_id() {
    return this.id;
  }

  String? get_user_name() {
    return this.name;
  }

  String? get_user_email() {
    return this.email;
  }

  String? get_user_password() {
    return this.password;
  }
}

Future<String?> getUserData(String email, String password) async {
  String? returnEmail = null;

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .get();

    final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
        snapshot.docs;
    for (var document in documents) {
      print(document.data()["email"]);
      print(document.data()["name"]);
      returnEmail = document.data()["email"];
    }

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    User userData = userCredential.user!;
  } on FirebaseException catch (e) {
    print(e.toString());
    print("Username or Password is Incorrect");
    // handle the Firebase authentication exception here
    if (e.code == "user-not-found" || e.code == "wrong-password") {
      // handle the case where the email and password do not match
    } else {
      // handle other Firebase authentication exceptions here
    }
  } catch (e) {
    print(e.toString());
    // handle other exceptions here
  }

  return returnEmail;
}

Future create_user(UserInfo user) async {
  final auth = FirebaseAuth.instance;

  try {
    final register = await auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
    //final docUser = FirebaseFirestore.instance.collection("users").doc("user1");
    final docUser = FirebaseFirestore.instance.collection("users").doc();
    User? userA = auth.currentUser;
    user.id = userA?.uid;
    final json = user.toJson();
    await docUser.set(json);
    await FirebaseAuth.instance.signOut();
  } on FirebaseAuthException catch (e) {
    print(e.toString());
    print("Error registering");
  }
}
