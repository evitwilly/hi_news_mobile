import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/data/static/screen_manager.dart';
import 'package:hi_news/data/status/response_status.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/helpers/debouncer.dart';
import 'package:hi_news/helpers/navigation_utils.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:hi_news/screens/network_news/network_news_detail_screen.dart';
import 'package:hi_news/screens/network_news/paging/my_paging_list_view.dart';
import 'package:hi_news/screens/network_news/paging/saved_news_list_view.dart';
import 'package:hi_news/screens/saved_news/saved_news_detail_screen.dart';
import 'package:hi_news/widgets/change_theme_action.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../resources/strings.dart';

class SearchScreen extends StatefulWidget {

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {

  final Repository _repository = new Repository();

  List<News> savedNews = [];
  List<News> allSavedNews = [];

  SearchBar searchBar;

  int selectedTabIndex = 0;

  final Debouncer debouncer = new Debouncer(milliseconds: 1000);
  
  String searchPattern;
  TextEditingController _searchController = new TextEditingController();

  bool isLoadingSavedNews = true;

  final PagingController<int, News> _pagingController = PagingController(firstPageKey: 1);
  TabController _tabController;

  SearchScreenState() {
    searchBar = new SearchBar(
      inBar: false,
      hintText: Strings.search,
      controller: _searchController,
      setState: setState,
      onChanged: (text) {
        debouncer.run(() => search(_searchController.text));
      },
        closeOnSubmit: false,
      onSubmitted: search,
      buildDefaultAppBar: buildAppBar
    );
    ScreenManager.searchState = this;
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_searchNetworkNews);
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(updateSelectTabIndex);
    searchBar.isSearching.addListener(onShowSearchBar);
    getSavedNews();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _buildTabsWithContent(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(updateSelectTabIndex);
    _pagingController.dispose();
    searchBar.isSearching.removeListener(onShowSearchBar);
  }

  void onShowSearchBar() {
    if (searchBar.isSearching.value) {
      setState(() {
        _searchController.text = searchPattern;
      });
    }
  }
  
  Widget _buildTabsWithContent() {
    return Scaffold(
      appBar: searchBar.build(context),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyPagingListView(
              _pagingController,
              _retryLastFailedRequest,
              _navigateToDetail,
              searchPattern: searchPattern),
          isLoadingSavedNews
              ? _buildCircularProgress()
              : SavedNewsListView(
              savedNews,
              _navigateToDetail,
              _removeItem,
              searchPattern: searchPattern,)
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(Strings.news),
      actions: [
        searchBar.getSearchAction(context),
        ChangeThemeAction(),
      ],
      bottom: _buildTabBar(),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(child: TextButton(child: Text(Strings.networkNews.toUpperCase()))),
        Tab(child: TextButton(child: Text(Strings.savedNews.toUpperCase()))),
      ],
    );
  }

  Widget _buildCircularProgress() => Center(child: CircularProgressIndicator());

  Future<void> _navigateToDetail(News oneNews, {bool isWasSaved = false}) async {
    Route<dynamic> currentDetailScreen;
    if (isWasSaved) {
      currentDetailScreen = NavigationUtils.createRoute(new SavedNewsDetailScreen(oneNews));
    } else {
      currentDetailScreen = NavigationUtils.createRoute(new NetworkNewsDetailScreen(oneNews));
    }
    Navigator.push(context, currentDetailScreen).then((isSaved) {
      if (isSaved == true) {
        final snackBar = SnackBar(
          content: Container(
            padding: EdgeInsets.all(3),
            child: Text(Strings.successfullySavedNews),
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        ScreenManager.screenState.getSavedNews();
        getSavedNews();
      }
    });
  }

  void search(String searchPattern) {
    setState(() {
      this.searchPattern = searchPattern;
      print(selectedTabIndex);
      if (selectedTabIndex == 0) {
        _pagingController.refresh();
      } else {
        _searchSavedNews();
      }
      _searchController.text = searchPattern;
    });
  }

  Future<void> _retryLastFailedRequest() async {
    var isAccessToInternet = await checkConnectivity();
    if (isAccessToInternet) {
      _pagingController.retryLastFailedRequest();
      _searchNetworkNews(_pagingController.nextPageKey);
    }
  }

  Future<void> _searchNetworkNews(int page) async {
    try {
      final responseStatus = await _repository.searchNews(searchPattern, page);

      if (responseStatus is NoExistsPageStatus) {
        _pagingController.appendLastPage([]);
        return;
      }
      final newItems = responseStatus.news;
      
      if (responseStatus is LastPageStatus) {
        _pagingController.appendLastPage(newItems);
        return;
      }

      _pagingController.appendPage(newItems, page + 1);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _searchSavedNews() async {
    final newSavedNews = allSavedNews.where((oneNews) =>
        isContainString(oneNews.title, searchPattern) ||
        isContainString(oneNews.content, searchPattern)
    ).toList();
    setState(() {
      savedNews = newSavedNews;
    });
  }

  Future<void> getSavedNews() async {
    setState(() {
      isLoadingSavedNews = true;
    });
    final news = await _repository.getAllSavedNews();
    setState(() {
      allSavedNews = news;
      savedNews = news;
      isLoadingSavedNews = false;
    });
  }

  Future<void> _removeItem(News oneNews) async {
    await _repository.delete(oneNews.id);
    ScreenManager.screenState.getSavedNews();
    setState(() {
      savedNews.remove(oneNews);
      allSavedNews.remove(oneNews);
    });
  }

  void updateSelectTabIndex() => selectedTabIndex = _tabController.index;
}
