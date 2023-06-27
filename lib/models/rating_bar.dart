import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingUpdate;
  final double barWidth;
  final double barHeight;

  const CustomRatingBar({
    required this.initialRating,
    required this.onRatingUpdate,
    required this.barWidth,
    required this.barHeight,
  });

  @override
  _CustomRatingBarState createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  double rating = 0;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        double barHeight = (index + 1) * widget.barHeight;
        return GestureDetector(
          onTap: () {
            double newRating = (index + 1).toDouble();
            setState(() {
              rating = newRating;
            });
            widget.onRatingUpdate(newRating);
          },
          child: Container(
            width: widget.barWidth,
            height: barHeight,
            margin: EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: rating >= (index + 1) ? Colors.amber : Colors.grey,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        );
      }),
    );
  }
}