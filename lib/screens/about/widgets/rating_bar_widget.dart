
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingBarWidget extends StatelessWidget {

  final double rating;
  final bool isReadOnly;
  final Function onRated;
  final double size;
  final double spacing;

  RatingBarWidget(this.rating, {
    this.isReadOnly: true,
    this.onRated,
    this.size = 26.0,
    this.spacing = 0.0});

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      starCount: 5,
      rating: rating,
      size: size,
      spacing: spacing,
      borderColor: Colors.orangeAccent,
      color: Colors.orangeAccent,
      isReadOnly: isReadOnly,
      onRated: onRated,
      allowHalfRating: false,
    );
  }

}