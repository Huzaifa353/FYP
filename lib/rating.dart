import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final double rating;

  Rating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        IconData iconData;
        if (index >= rating) {
          iconData = Icons.star_border;
        } else if (index > rating - 1 && index < rating) {
          iconData = Icons.star_half;
        } else {
          iconData = Icons.star;
        }

        return Icon(
          iconData,
          color: Colors.amber,
        );
      }),
    );
  }
}
