import 'package:flutter/material.dart';

class CardPayment extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Payment',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _cardNumber;
  late String _expiryDate;
  late String _cvv;
  late String _billingZip;

  int _selectedIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 70,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: const [
                      Image(
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        image: NetworkImage(
                          'https://img.icons8.com/color/480/null/visa.png',
                        ),
                      ),
                      Image(
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        image: NetworkImage(
                          'https://img.icons8.com/color/480/000000/mastercard-logo.png',
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Add Payment information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Card number', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a card number';
                      }
                      return null;
                    },
                    onSaved: (value) => _cardNumber = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Expiry date', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an expiry date';
                      }
                      return null;
                    },
                    onSaved: (value) => _expiryDate = value!,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'CVV', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a CVV';
                      }
                      return null;
                    },
                    onSaved: (value) => _cvv = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Billing ZIP', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a billing ZIP';
                      }
                      return null;
                    },
                    onSaved: (value) => _billingZip = value!,
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Process payment here
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Continue',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 29,
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
