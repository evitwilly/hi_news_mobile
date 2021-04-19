
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:hi_news/data/repository.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:hi_news/widgets/change_theme_action.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Repository repository = new Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.aboutUs),
        actions: [
          ChangeThemeAction(),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(child: Column(
      children: [
        Image.asset("images/title_image.webp"),
        Html(
          data: Strings.aboutUsHtml,
          style: {
            "p" : Style(
              fontSize: FontSize(20),
              margin: EdgeInsets.only(left: 3, right: 6, top: 10),
            )
          },
          onLinkTap: _launchURL,
        ),
      ],
    ), );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}