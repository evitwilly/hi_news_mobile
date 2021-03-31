
import 'package:flutter/material.dart';
import 'package:hi_news/screens/about/widgets/rating_bar_widget.dart';

class ReviewHeader extends StatelessWidget {

  final double rating;
  final int reviewCount;
  ReviewHeader(this.rating, this.reviewCount);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rating.toStringAsPrecision(2),
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 10, top: 5),
              child: RatingBarWidget(rating),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child:
              Text("(" + reviewCount.toString() + ")"),
            )
          ],
        )
      ],
    );
  }

}