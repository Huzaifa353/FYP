import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mazdoor_pk/homeProducts.dart';
import 'package:mazdoor_pk/Product.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final controlTitle = TextEditingController();
  final controlDescription = TextEditingController();
  final controlBasePrice = TextEditingController();
  final controlActualPrice = TextEditingController();

  String category = 'Electronics';
  DateTime _selectedDate = DateTime.now();
  // List of items in our dropdown menu
  var items = ['Electronics', 'Home Decorations', 'Jewellery', 'Other'];

  Duration selectedTime = Duration(
    hours: DateTime.now().hour,
    minutes: DateTime.now().minute,
  );

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(_selectedDate.year),
        lastDate:
            DateTime((_selectedDate.add(const Duration(days: 365)).year)));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future create_product(Product product) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final docProduct = FirebaseFirestore.instance.collection("Product").doc();
      product.user = auth.currentUser!.uid;
      product.userEmail = auth.currentUser!.email;
      String? downloadURL;
      if (_imageFile != null) {
        downloadURL = await uploadFile(_imageFile!);
      }
      product.image = downloadURL;
      final json = product.toJson();
      await docProduct.set(json);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      print("Error Adding Product");
    }
  }

  File? _imageFile;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      // Create a Reference to the file location
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Cloud Storage
      await ref.putFile(file);

      // Get the download URL
      String downloadURL = await ref.getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            shadowColor: Colors.transparent,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: (() {
                  Navigator.pop(context);
                }))),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "Add your Product",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                          fontFamily: 'Nunito'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      height: 60,
                      child: InputDecorator(
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 39, 193, 136),
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Product Category',
                              labelStyle: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                              ),
                              border: OutlineInputBorder()),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                value: category,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                // Array list of items
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    category = newValue!;
                                  });
                                }),
                          ))),
                  const SizedBox(height: 15),
                  SizedBox(
                    child: Column(
                      children: [
                        if (_imageFile != null) ...[
                          Image.file(_imageFile!),
                          SizedBox(height: 20),
                        ],
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.upload),
                          label: Text('Upload Image'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                        controller: controlTitle,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 39, 193, 136),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          floatingLabelStyle: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 39, 193, 136)),
                          contentPadding: EdgeInsets.all(10),
                        )),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                        controller: controlDescription,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 39, 193, 136),
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                          floatingLabelStyle: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 39, 193, 136)),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            height: 1.6)),
                  ),
                  const SizedBox(height: 18),
                  const Text('When to End the Bid?',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          fontFamily: 'Nunito')),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Select Date',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 39, 193, 136),
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.calendar_today,
                              color: Color.fromARGB(255, 39, 193, 136),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CupertinoTimerPicker(
                                onTimerDurationChanged: (Duration newTimer) {
                                  setState(() {
                                    selectedTime = newTimer;
                                  });
                                },
                                initialTimerDuration: selectedTime,
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Select Time',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 39, 193, 136),
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w500)),
                            SizedBox(width: 8),
                            Icon(
                              Icons.access_time_filled_rounded,
                              color: Color.fromARGB(255, 39, 193, 136),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: TextFormField(
                              controller: controlBasePrice,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 39, 193, 136),
                                    width: 2.0,
                                  ),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Base Price',
                                floatingLabelStyle: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 39, 193, 136)),
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 80, 232, 176)),
                          onPressed: (() {
                            final newProduct = Product(
                                category: category,
                                title: controlTitle.text,
                                description: controlDescription.text,
                                basePrice:
                                    int.tryParse(controlBasePrice.text) ?? 0,
                                currentBid:
                                    int.tryParse(controlBasePrice.text) ?? 0);
                            newProduct.setTime(_selectedDate, selectedTime);
                            create_product(newProduct);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeProducts()));
                          }),
                          child: const Text('Add Product',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
