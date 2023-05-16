import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
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

  Product({
    this.id,
    this.user,
    this.userEmail,
    this.image,
    this.status,
    required this.category,
    required this.title,
    required this.description,
    required this.basePrice,
    this.currentBid,
    this.time,
  });

  setProduct(String category, String title, String description, int basePrice,
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
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
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
      );

  factory Product.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return Product(
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
        status: data['status']);
  }
}
