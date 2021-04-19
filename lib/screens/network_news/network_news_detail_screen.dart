import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/data/static/screen_manager.dart';
import 'package:hi_news/data/status/content_response_status.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/widgets/news_content.dart';
import 'package:share/share.dart';

import 'widgets/content_failed.dart';

class NetworkNewsDetailScreen extends StatefulWidget {

  News oneNews;

  NetworkNewsDetailScreen(this.oneNews);

  @override
  _NetworkNewsDetailScreen createState() => _NetworkNewsDetailScreen();
}

class _NetworkNewsDetailScreen extends State<NetworkNewsDetailScreen> {

  final Repository repository = new Repository();

  var _isSaving = false;
  var _isDisabledShareButton = true;
  var _isDisabledSaveButton = true;

  bool isError = false;
  bool isEmptyContent = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getContent();
  }

  Future<void> _getContent() async {

    final status = await repository.updateNews(widget.oneNews);

    if (status is ErrorContentStatus) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      return;
    }

    setState(() {
      if (status is NoExistsContentStatus) {
        isEmptyContent = true;
      } else {
        widget.oneNews = status.oneNews;
      }
      isLoading = false;
      _isDisabledSaveButton = false;
      _isDisabledShareButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(Strings.aboutNews),
          actions: [_buildShareAction(), _buildSaveAction()]
      ),
      body: isLoading ? _buildContentIndicator() : _buildContent(),
    );
  }


  Widget _buildContent() {
    if (isError) {
      return ContentFailed(_getContent);
    }
    if (isEmptyContent) {
      return Center(child: Text(Strings.notContent),);
    }
    return _isSaving ? _buildLoadingProgress() : NewsContent(widget.oneNews);
  }

  Widget _buildLoadingProgress() {
    return Stack(
      children: [
        NewsContent(widget.oneNews),
        Positioned.fill(
          child: Container(
            color: Color(0x6F000000),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  IconButton _buildShareAction() {
    return IconButton(
      icon: Icon(Icons.share_outlined),
      tooltip: Strings.shareNews,
      onPressed: _isDisabledShareButton ? null : _shareNews,
    );
  }

  IconButton _buildSaveAction() {
    return IconButton(
        icon: Icon(Icons.save),
        tooltip: Strings.saveNews,
        onPressed: _isDisabledSaveButton ? null : _saveNews
    );
  }

  void _shareNews() async {
    String content = "";
    (jsonDecode(widget.oneNews.content) as List<dynamic>).forEach((jsonObject) {
      if (jsonObject['type'] == 'text') {
        content += removeAllHtmlTags(jsonObject['text']);
      }
    });
    Share.share(content, subject: widget.oneNews.title);
  }

  Future<void> _saveNews() async {
    setState(() {
      _isDisabledSaveButton = true;
      _isSaving = true;
    });
    await repository.insert(widget.oneNews);
    ScreenManager.screenState.getSavedNews();
    ScreenManager.searchState.getSavedNews();
    if (context != null) {
      Navigator.of(context).pop(true);
    }
    setState(() {
      _isDisabledSaveButton = false;
      _isSaving = false;
    });
  }

  Widget _buildContentIndicator() => Center(child: CircularProgressIndicator());

}
