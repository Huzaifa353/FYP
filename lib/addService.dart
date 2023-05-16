import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazdoor_pk/Service.dart';
import 'package:mazdoor_pk/homeServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final controlTitle = TextEditingController();
  final controlDescription = TextEditingController();
  final controlBasePrice = TextEditingController();
  final controlActualPrice = TextEditingController();
  bool? emergency = false;

  String category = 'Electrician';
  DateTime _selectedDate = DateTime.now();
  // List of items in our dropdown menu
  var items = [
    'Electrician',
    'Plumber',
    'Freelancing',
    'Catering',
    'Photography',
    'Event Planning',
    'Web Development',
    'Graphic Design',
    'Writing and Editing',
    'Fitness Training',
    'Home Cleaning',
    'Tutoring',
    'Personal Stylist',
    'Landscaping',
    'Car Repair',
    'Appliance Repair',
    'Interior Design',
    'Pest Control',
    'Home Renovation',
    'Painting Services',
    'Moving and Packing',
    'Home Security Installation',
    'Furniture Assembly',
    'Roofing Services',
    'Carpentry Services',
    'HVAC Services',
    'Window Cleaning'
  ];

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

  Future create_service(Service service) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final docService = FirebaseFirestore.instance.collection("Service").doc();
      service.user = auth.currentUser!.uid;
      service.userEmail = auth.currentUser!.email;
      service.status = "running";
      String? downloadURL;
      if (_imageFile != null) {
        downloadURL = await uploadFile(_imageFile!);
      }
      service.image = downloadURL;
      final json = service.toJson();
      await docService.set(json);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      print("Error Adding Service");
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
                      "Specify the Service you Need",
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
                              labelText: 'Service Category',
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
                          const SizedBox(height: 20),
                        ],
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload),
                          label: const Text('Upload Image'),
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
                          labelText: 'Problem Title',
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
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Checkbox(
                          value: emergency,
                          onChanged: (bool? value) {
                            setState(() {
                              this.emergency = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Is it needed in emergency?',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                    ], //<Widget>[]
                  ),
                  const SizedBox(height: 18),
                  const Text('When You need it?',
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
                    child: SizedBox(
                      width: 200,
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
                            labelText: 'Expected Price',
                            floatingLabelStyle: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 39, 193, 136)),
                            contentPadding: EdgeInsets.all(10),
                          )),
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
                            final newService = Service(
                                category: category,
                                title: controlTitle.text,
                                description: controlDescription.text,
                                basePrice:
                                    int.tryParse(controlBasePrice.text) ?? 0,
                                currentBid:
                                    int.tryParse(controlBasePrice.text) ?? 0);
                            newService.setTime(_selectedDate, selectedTime);
                            create_service(newService);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeServices()));
                          }),
                          child: const Text('Post Service',
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
