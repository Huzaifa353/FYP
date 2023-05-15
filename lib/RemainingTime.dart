import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemainingTime extends StatefulWidget {
  Timestamp timestamp;

  RemainingTime({required this.timestamp});

  @override
  _RemainingTimeState createState() => _RemainingTimeState();
}

class _RemainingTimeState extends State<RemainingTime> {
  late Timer _timer;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _duration = widget.timestamp.toDate().difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _duration - const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_duration.inHours}h ${(_duration.inMinutes % 60).toString().padLeft(2, '0')}m ${(_duration.inSeconds % 60).toString().padLeft(2, '0')}s',
      style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 193, 122)),
    );
  }
}
