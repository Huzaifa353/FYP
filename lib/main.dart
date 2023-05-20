import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mazdoor_pk/welcome.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mazdoor_pk/notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handing a backgorund message with id ${message.messageId}");
}

void _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null)
    print("Message also contained a notification: ${message.notification}");
}

void requestPushNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    announcement: true, // Enable to receive FCM announcements
  );
}

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  requestPushNotificationPermission();

  FirebaseMessaging.onBackgroundMessage(
      (message) => _firebaseMessagingBackgroundHandler(message));

  FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessage.listen((event) {
    if (event.notification != null) {
      _firebaseMessagingForegroundHandler(event);
    }
  });
  final fcpmtoken = await FirebaseMessaging.instance.getToken();

  print(fcpmtoken);
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
