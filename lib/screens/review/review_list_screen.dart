import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/domain/review.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/screens/about/widgets/rating_bar_widget.dart';
import 'package:hi_news/screens/review/widgets/review_header.dart';
import 'package:hi_news/widgets/diamond_information_widget.dart';
import 'package:hi_news/widgets/leading_icon.dart';
import 'package:hi_news/widgets/my_elevated_button.dart';

import 'review_edit_screen.dart';


class ReviewListScreen extends StatefulWidget {

  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final Repository repository = new Repository();
  bool isLoading = true;
  bool isError = false;
  List<Review> reviews;
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.reviews),
        leading: LeadingIcon(),
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isError) {
      return ContentFailed(_loadReviews);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReviewHeader(),
        _buildWriteReviewButton(),
        _buildReviews(),
      ],
    );
  }

  Widget _buildReviewHeader() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: ReviewHeader(rating, reviews.length),
    );
  }

  Widget _buildWriteReviewButton() {
    return Container(
        margin: EdgeInsets.only(left: 16),
        child: MyElevatedButton(
          Strings.writeReview, _navigateToReviewEditScreen
        )
    );
  }

  Widget _buildReviews() {
    return Expanded(child: Container(
      margin: EdgeInsets.only(top: 20),
      child: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey)
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                          reviews[index].name,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          )
                      ),
                    ),
                    Container(
                      child: Text(reviews[index].date),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 6),
                  child: RatingBarWidget(reviews[index].rating),
                ),
                Container(
                  child: Text(reviews[index].text),
                ),
              ],
            ), );
        },
      ),)
    );
  }

  void _navigateToReviewEditScreen() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ReviewEditScreen())
    ).whenComplete(_loadReviews);
  }

  void _loadReviews() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      final newReviews = await repository.getReviews();
      final newRating = newReviews.map((review) => review.rating)
          .fold(rating, (previous, current) => previous + current) /
          newReviews.length;
      setState(() {
        reviews = newReviews;
        rating = newRating;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

}