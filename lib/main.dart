import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazdoor_pk/welcome.dart';
import 'package:mazdoor_pk/select.dart';
import 'package:mazdoor_pk/addService.dart';
import 'package:mazdoor_pk/homeServices.dart';
import 'package:mazdoor_pk/homeProducts.dart';
import 'package:mazdoor_pk/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
