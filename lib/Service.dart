import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String? id;
  String? user;
  String? userEmail;
  String? status;
  String category;
  String title;
  String description;
  int basePrice;
  int? currentBid;
  String? image;
  Timestamp? time;
  bool? emergency;

  Service({
    this.id,
    this.user,
    this.userEmail,
    this.image,
    this.status,
    this.emergency,
    required this.category,
    required this.title,
    required this.description,
    required this.basePrice,
    this.currentBid,
    this.time,
  });

  setService(String category, String title, String description, int basePrice,
      int currentBid, DateTime endDate, Duration endTime) {
    this.category = category;
    this.title = title;
    this.description = description;
    this.basePrice = basePrice;
    this.currentBid = currentBid;
    time = Timestamp.fromDate(endDate.add(endTime));
  }

  setTime(DateTime endDate, Duration endTime) {
    time = Timestamp.fromDate(endDate.add(endTime));
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'userEmail': userEmail,
        'category': category,
        'title': title,
        'description': description,
        'basePrice': basePrice,
        'currentBid': currentBid,
        'image': image,
        'time': time,
        'status': status,
        'emergency': emergency,
      };

  static Service fromJson(Map<String, dynamic> json) => Service(
        user: json['user'],
        userEmail: json['userEmail'],
        category: json['category'],
        title: json['title'],
        description: json['description'],
        basePrice: json['basePrice'],
        currentBid: json['currentBid'],
        image: json['image'],
        time: json['time'],
        status: json['status'],
        emergency: json['emergency'],
      );

  factory Service.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return Service(
        id: document.id,
        user: data['user'],
        userEmail: data['userEmail'],
        category: data['category'],
        title: data['title'],
        description: data['description'],
        basePrice: data['basePrice'],
        currentBid: data['currentBid'],
        image: data['image'],
        time: data['time'],
        status: data['status'],
        emergency: data['emergency']);
  }
}
