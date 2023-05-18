import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  final int starCount;
  final void Function(int rating) onRatingChanged;

  const RatingBar({
    //Key key,
    required this.starCount,
    required this.onRatingChanged,
  }) //: super(key: key)
  ;

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int _currentRating = 0;

  void _updateRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
    widget.onRatingChanged(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.starCount, (index) {
        final int rating = index + 1;
        return GestureDetector(
          onTap: () => _updateRating(rating),
          child: Icon(
            rating <= _currentRating ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 32.0,
          ),
        );
      }),
    );
  }
}
