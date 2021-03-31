import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:share/share.dart';

import 'widgets/saved_news_content.dart';

class SavedNewsDetailScreen extends StatefulWidget {

  News oneNews;

  SavedNewsDetailScreen(this.oneNews);

  @override
  _SavedNewsDetailScreen createState() => _SavedNewsDetailScreen();
}

class _SavedNewsDetailScreen extends State<SavedNewsDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final noExistsContent = widget.oneNews.content == null || widget.oneNews.content.isEmpty;

    return Scaffold(
      appBar: AppBar(
          title: Text(Strings.aboutNews),
          actions: [_buildShareAction()]
      ),
      body: noExistsContent ? _buildContentIndicator() : SavedNewsContent(widget.oneNews),
    );
  }

  IconButton _buildShareAction() {
    return IconButton(
      icon: Icon(Icons.share_outlined),
      tooltip: Strings.shareNews,
      onPressed: _shareNews,
    );
  }

  void _shareNews() => Share.share(widget.oneNews.content, subject: widget.oneNews.title);

  Widget _buildContentIndicator() => Center(child: CircularProgressIndicator());

}
