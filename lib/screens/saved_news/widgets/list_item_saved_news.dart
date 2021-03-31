
import 'package:flutter/material.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/widgets/list_item_news.dart';


class ListItemSavedNews extends ListItemNews {

  final News oneNews;
  final Function removeItem;
  final String searchPattern;
  final Function moreClick;

  ListItemSavedNews(
      this.oneNews,
      this.moreClick,
      this.removeItem,
      {this.searchPattern = ""}): super(oneNews, moreClick, searchPattern: searchPattern);

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
              moreClick(oneNews, isWasSaved: true);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTitle(context, oneNews.title),
                _buildImage(oneNews.urlToImage),
                buildDescription(context, oneNews.desc),
                buildAuthor(oneNews.author),
                buildDate(oneNews.date),
              ],
            ),
          ),
          buildButtonMore(context, oneNews, bottom: 0.0, isWasSaved: true),
          _buildButtonRemove(),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    print("_buildImage()");
    print(imageUrl);
    return Image.asset(imageUrl);
  }

  Widget _buildButtonRemove() {
    return Container(
      margin: EdgeInsets.only(left: 7, right: 7, bottom: 10),
      child: OutlinedButton(
        onPressed: removeItem,
        child: Text(Strings.remove.toUpperCase()),
      ),
    );
  }

}