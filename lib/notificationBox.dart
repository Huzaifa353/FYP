import 'package:flutter/material.dart';

class NotificationBox extends StatelessWidget {
  var notification;
  NotificationBox({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 240, 240, 240),
                  )
                ]),
            child: Text.rich(
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  height: 1.8),
              TextSpan(
                children: [
                  TextSpan(
                    text: notification["time"].toString(),
                  ),
                  TextSpan(
                    // ignore: prefer_interpolation_to_compose_strings
                    text: "\n" + notification['senderEmail'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    // ignore: prefer_interpolation_to_compose_strings
                    text: " - " + notification['data'],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
