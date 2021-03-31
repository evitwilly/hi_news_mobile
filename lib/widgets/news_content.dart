
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';

class NewsContent extends StatelessWidget {

  final News oneNews;
  NewsContent(this.oneNews);

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    final items = (json.decode(oneNews.content) as List<dynamic>).map((jsonObject) {
      if (jsonObject['type'] == 'text') {
        return Html(data: jsonObject['text'], onLinkTap: launchURL,
          style: {
            "p" : Style(
              fontSize: FontSize(18),
            ),
            "ul" : Style(
              fontSize: FontSize(17),
            ),
            "ol" : Style(
              fontSize: FontSize(17),
            ),
            "h1" : Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              textAlign: TextAlign.left,
            ),
            "h2" : Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              textAlign: TextAlign.left,
            ),
            "h3" : Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              textAlign: TextAlign.left,
            )
          });
      } else {
        return PinchZoomImage(
          image: CachedNetworkImage(
            imageUrl: jsonObject['img'],
            placeholder: (context, str) =>
                Container(
                    padding: EdgeInsets.all(60),
                    child: Center(child: CircularProgressIndicator()
                    )
                ),
            errorWidget: (context, string, dynamic) => Image.asset("images/no_access_internet.png"),
        ), );
      }
    }).toList();

    items.insert(0, _buildTitle());
    items.add(_buildAuthor());
    items.add(_buildDate());

    return ListView(children: items,);
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.all(7),
      child: Text(oneNews.title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
      ),
    );
  }

  Widget _buildAuthor() {
    return Container(
      margin: EdgeInsets.all(7),
      child: Text(oneNews.author,
          textAlign: TextAlign.end, style: TextStyle(fontSize: 17)),
    );
  }

  Widget _buildDate() {
    return Container(
      margin: EdgeInsets.all(7),
      child: Text(
          oneNews.date,
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 17)
      ),
    );
  }

}