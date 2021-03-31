import 'package:flutter/cupertino.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/screens/network_news/indicators/first_page_error_indicator.dart';
import 'package:hi_news/screens/network_news/indicators/new_page_error_indicator.dart';
import 'package:hi_news/screens/network_news/indicators/no_items_found_indicator.dart';
import 'package:hi_news/screens/network_news/indicators/no_more_items_indicator.dart';
import 'package:hi_news/widgets/list_item_news.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MyPagingListView extends StatelessWidget {

  final PagingController _pagingController;
  final Function _retryLastFailedRequest;
  final Function moreClick;
  final String searchPattern;

  MyPagingListView(
      this._pagingController,
      this._retryLastFailedRequest,
      this.moreClick,
      {this.searchPattern = ""});
  
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, News>(
      padding: EdgeInsets.only(top: 16),
      pagingController: _pagingController,

      builderDelegate: PagedChildBuilderDelegate<News>(
        itemBuilder: (context, item, index) => ListItemNews(item, moreClick, searchPattern: searchPattern,),
        firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(() {
          _pagingController.refresh();
        }),
        newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(() {
          _retryLastFailedRequest();
        }),
        noItemsFoundIndicatorBuilder: (_) => NoItemsFoundIndicator(),
        noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
      ),
    );
  }
}