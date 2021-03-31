
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/resources/constants.dart';
import 'package:hi_news/resources/strings.dart';

class ListItemNews extends StatelessWidget {

  final Function moreClick;
  final News oneNews;
  final String searchPattern;

  ListItemNews(this.oneNews, this.moreClick, {this.searchPattern = ""});

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              moreClick(oneNews, isWasSaved: false);
            },
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTitle(context, oneNews.title),
                buildImage(oneNews.urlToImage),
                buildDescription(context, oneNews.desc),
                buildAuthor(oneNews.author),
                buildDate(oneNews.date),
              ],
            ),
          ),
          buildButtonMore(context, oneNews),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context, String title) {
    if (searchPattern == null || searchPattern.isEmpty) {
      return Container(
        margin: EdgeInsets.all(7),
        child: Text(title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      );
    }
    final isLight = ThemeProvider.of(context).brightness == Brightness.light;
    return Container(
        margin: EdgeInsets.all(7),
        child: DynamicTextHighlighting(
          text: title,
          highlights: [ searchPattern ],
          color: isLight ? Colors.yellow : Colors.green[500],
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isLight ? Colors.black : Colors.white),
          caseSensitive: false,
        )
    );
  }

  Widget buildImage(String imgUrl) {
    return CachedNetworkImage(
          errorWidget: (context, _, dynamic) => Image.asset(Constants.PLACEHOLDER_IMAGE),
          imageUrl: imgUrl,
    );
  }

  Widget buildDescription(BuildContext context, String description) {
    if (searchPattern == null || searchPattern.isEmpty) {
      return Container(
        margin: EdgeInsets.all(7),
        child: Text(
            description,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 20)
        ),
      );
    }
    final isLight = ThemeProvider.of(context).brightness == Brightness.light;
    return Container(
      margin: EdgeInsets.all(7),
      child: DynamicTextHighlighting(
        text: description,
        highlights: [ searchPattern ],
        textAlign: TextAlign.justify,
        style: TextStyle(
            fontSize: 20,
            color: isLight ? Colors.black : Colors.white),
        color: isLight ? Colors.yellow : Colors.green[500],
        caseSensitive: false,
      ),
    );
  }

  Widget buildAuthor(String author) {
    return Container(
      margin: EdgeInsets.all(7),
      child: Text(
          author,
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 17)
      ),
    );
  }

  Widget buildDate(String date) {
    return Container(
      margin: EdgeInsets.all(7),
      child: Text(
          date,
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 17)
      ),
    );
  }

  Widget buildButtonMore(BuildContext context, News one, {bottom = 7.0, isWasSaved = false}) {
    return Container(
      margin: EdgeInsets.only(left: 7, right: 7, top: 7, bottom: bottom),
      child: OutlinedButton(
        onPressed: () {
          moreClick(oneNews, isWasSaved: isWasSaved);
        },
        child: Text(
          Strings.more.toUpperCase(),
        ),
      ),
    );
  }

}