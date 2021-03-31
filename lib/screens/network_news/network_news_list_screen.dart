import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hi_news/data/preferences.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/data/status/response_status.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/helpers/navigation_utils.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:hi_news/domain/news_filter.dart';
import 'package:hi_news/screens/network_news/paging/my_paging_list_view.dart';
import 'package:hi_news/widgets/change_theme_action.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../resources/strings.dart';
import 'network_news_detail_screen.dart';
import 'network_news_filter_screen.dart';

class NetworkNewsListScreen extends StatefulWidget {
  final PagingController<int, News> pagingController = PagingController(firstPageKey: 1);

  @override
  _NetworkNewsListState createState() => _NetworkNewsListState();
}

class _NetworkNewsListState extends State<NetworkNewsListScreen> {

  Repository _repository = new Repository();
  NetworkNewsFilter filter;
  
  @override
  void initState() {
    widget.pagingController.addPageRequestListener(_loadNews);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: MyPagingListView(
          widget.pagingController,
          _retryLastFailedRequest,
          _navigateToDetail
      ),
    );
  }

  @override
  void dispose() {
    widget.pagingController.dispose();
    super.dispose();
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
    final filterPage = NavigationUtils.createRoute(new NetworkNewsFilterScreen());
    Navigator.of(context).push(filterPage).then((filter) {
      if (filter != null && filter is NetworkNewsFilter) {
        this.filter = filter;
        widget.pagingController.refresh();
      }
    });
  }

  Future<void> _navigateToDetail(News oneNews, {bool isWasSaved = false}) async {
    final page = NavigationUtils.createRoute(NetworkNewsDetailScreen(oneNews));
    Navigator.push(context, page).then((isSaved) {
      if (isSaved == true) {
        final snackBar = SnackBar(
          content: Container(
            padding: EdgeInsets.all(3),
            child: Text(Strings.successfullySavedNews),
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });
  }

  Future<void> _retryLastFailedRequest() async {
    var isAccessToInternet = await checkConnectivity();
    if (isAccessToInternet) {
      widget.pagingController.retryLastFailedRequest();
      _loadNews(widget.pagingController.nextPageKey);
    }
  }

  Future<void> _loadNews(int page) async {
    if (filter == null) {
      final newFilter = await Preferences.getNetworkNewsFilter();
      print(newFilter);
      filter = newFilter;
    }
    final themeId = filter.themeId;
    final authorNames = filter.authorNames;

    try {

      final responseStatus = await _repository.loadNews(themeId, page);

      if (responseStatus is NoExistsPageStatus) {
        widget.pagingController.appendLastPage([]);
        return;
      }

      final newItems = responseStatus.news;

      final filteredItems = authorNames.join(" ").trim().isEmpty
          ? newItems
          : newItems.where((News item) =>
          authorNames.any((authorName) => isMatchString(item.author, authorName))).toList();


      if (responseStatus is LastPageStatus) {
        widget.pagingController.appendLastPage(filteredItems);
        return;
      }

      widget.pagingController.appendPage(filteredItems, page + 1);
    } catch (error) {
      widget.pagingController.error = error;
    }
  }

}
