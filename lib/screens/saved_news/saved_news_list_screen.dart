import 'package:flutter/material.dart';
import 'package:hi_news/data/preferences.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/data/static/screen_manager.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/domain/news_filter.dart';
import 'package:hi_news/helpers/navigation_utils.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/screens/network_news/paging/saved_news_list_view.dart';
import 'package:hi_news/screens/saved_news/saved_news_filter_screen.dart';
import 'package:hi_news/widgets/change_theme_action.dart';

import 'saved_news_detail_screen.dart';
import 'widgets/not_saved_news_message.dart';

class SavedNewsListScreen extends StatefulWidget {
  @override
  SavedNewsListScreenState createState() => SavedNewsListScreenState();
}

class SavedNewsListScreenState extends State<SavedNewsListScreen> {
  final Repository _repository = new Repository();
  SavedNewsFilter filter;
  List<News> allNews = [];
  List<News> savedNews = [];
  bool isLoadingSavedNews = true;

  @override
  void initState() {
    super.initState();
    getSavedNews();
    ScreenManager.screenState = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: allNews.length == 0
          ? NotSavedNewsMessage()
          : SavedNewsListView(savedNews, _navigateToDetail, _removeItem),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(Strings.news),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list_rounded),
          tooltip: Strings.filterNews,
          onPressed: () {
            _navigateToFilter();
          },
        ),
        ChangeThemeAction(),
      ],
    );
  }

  Future<void> _navigateToFilter() async {
    final filterPage = NavigationUtils.createRoute(new SavedNewsFilterScreen());
    Navigator.of(context).push(filterPage).then((filter) {
      if (filter != null && filter is SavedNewsFilter) {
        this.filter = filter;
        getSavedNews();
      }
    });
  }

  Future<void> _navigateToDetail(News oneNews,
      {bool isWasSaved = false}) async {
    final page = NavigationUtils.createRoute(SavedNewsDetailScreen(oneNews));
    Navigator.push(context, page).then((isSaved) {
      if (isSaved == true) {
        final snackBar = SnackBar(
          content: Container(
            padding: EdgeInsets.all(3),
            child: Text(Strings.successfullySavedNews),
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        getSavedNews();
      }
    });
  }

  Future<void> getSavedNews() async {
    if (filter == null) {
      filter = await Preferences.getSavedNewsFilter();
    }

    setState(() {
      isLoadingSavedNews = true;
    });

    final allNews = await _repository.getAllSavedNews();
    final news = await _repository.getFilteredSavedNews(filter);

    print("$allNews");
    print("$news");

    setState(() {
      this.allNews = allNews;
      this.savedNews = news;
      this.isLoadingSavedNews = false;
    });
  }

  Future<void> _removeItem(News oneNews) async {
    await _repository.delete(oneNews.id);
    ScreenManager.searchState.getSavedNews();
    savedNews.remove(oneNews);
  }
}
