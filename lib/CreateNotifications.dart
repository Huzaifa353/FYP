import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createNotificationExtra(
    String buyerEmail,
    String data,
    String userType,
    String messageType,
    String serviceId,
    String title,
    String category,
    final time,
    String sellerEmail,
    double totalBill,
    String sellerName,
    String buyerName) async {
  Timestamp now = Timestamp.now();
  DateTime dateTime = now.toDate();
  CollectionReference mainCollectionRef =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot snapshot =
      await mainCollectionRef.where('email', isEqualTo: buyerEmail).get();

  String docID = snapshot.docs.first.id;
  DocumentReference docRef = mainCollectionRef.doc(docID);

  docRef.collection("notification").add({
    'data': data,
    'sender': buyerEmail,
    'time': dateTime.toString(),
    'user': userType,
    'messageType': messageType,
    'id': serviceId,
    'title': title,
    'category': category,
    'time': time,
    'sellerEmail': sellerEmail,
    'totalBill': totalBill,
    'sellerName': sellerName,
    'buyerName': buyerName,
  });
}

class CreateNotificationsExtra {
  CreateNotificationsExtra(
      String senderEmail,
      String data,
      String userType,
      String messageType,
      String serviceId,
      String title,
      String category,
      final time,
      String sellerEmail,
      double totalBill,
      String sellerName,
      String buyerName) {
    createNotificationExtra(senderEmail, data, userType, messageType, serviceId,
        title, category, time, sellerEmail, totalBill, sellerName, buyerName);
  }
}
