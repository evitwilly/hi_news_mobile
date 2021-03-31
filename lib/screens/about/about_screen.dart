
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/screens/review/review_list_screen.dart';
import 'package:hi_news/widgets/change_theme_action.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/rating_bar_widget.dart';

class AboutScreen extends StatefulWidget {

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Repository repository = new Repository();
  double rating;

  void initState() {
    super.initState();
    _initRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.aboutUs),
        actions: [
          ChangeThemeAction(),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(child: Column(
      children: [
        Image.asset("images/title_image.webp"),
        rating == null ? Container() : _buildRatingBar(),
        Html(
          data: Strings.aboutUsHtml,
          style: {
            "p" : Style(
              fontSize: FontSize(20),
              margin: EdgeInsets.only(left: 3, right: 6, top: 10),

            )
          },
          onLinkTap: _launchURL,
        ),
      ],
    ), );
  }

  Widget _buildRatingBar() {
    return Container(

      child: InkWell(
        onTap: _navigateToReviewScreen,
        child: Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBarWidget(rating),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _navigateToReviewScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ReviewListScreen())
    );
  }

  void _initRating() async {
    try {

      final reviews = await repository.getReviews();
      final commonRating = reviews.map((review) => review.rating)
          .fold(0.0, (previous, next) => previous + next);
      final newRating = reviews.length > 0
          ? commonRating / reviews.length.toDouble()
          : 0.0;
      setState(() {
        rating = newRating;
      });

    } catch (e) {

    }

  }

}