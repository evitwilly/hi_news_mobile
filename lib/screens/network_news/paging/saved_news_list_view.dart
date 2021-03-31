
import 'package:flutter/material.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/screens/saved_news/widgets/filter_not_found_message.dart';
import 'package:hi_news/screens/saved_news/widgets/list_item_saved_news.dart';

class SavedNewsListView extends StatelessWidget {

  final List<News> savedNews;
  final Function moreClick;
  final Function removeItem;
  final String searchPattern;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  SavedNewsListView(
      this.savedNews,
      this.moreClick,
      this.removeItem,
      {this.searchPattern = ""});

  @override
  Widget build(BuildContext context) {
    return savedNews.length == 0
        ? FilterNotFoundMessage()
        : _buildSavedNews();
  }

  Widget _buildSavedNews() {
    return AnimatedList(
      key: listKey,
      initialItemCount: savedNews.length ,
      itemBuilder: (context, index, animation) {
        return buildItem(index, savedNews[index], animation);
      },
    );
  }

  Widget buildItem(int index, News oneNews, animation) {
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(animation),
        child: ListItemSavedNews(
            oneNews,
            moreClick,
            () { remove(index, oneNews); },
            searchPattern: searchPattern,)
    );
  }

  void remove(index, oneNews) {
    listKey.currentState.removeItem(
        index, (ctx, animation) => buildItem(index, oneNews, animation),
        duration: const Duration(milliseconds: 700)
    );
    removeItem(oneNews);
  }
}


