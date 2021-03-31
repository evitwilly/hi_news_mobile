import 'package:floor/floor.dart';
import 'package:html_unescape/html_unescape.dart';

var htmlUnescape = new HtmlUnescape();

@Entity(tableName: "news")
class News {

  @PrimaryKey(autoGenerate: true)
  final int id;

  String url;
  String urlToImage;
  String title;
  String author;
  String date;
  String desc;
  String themeNames;
  String content;

  News(this.id, this.url, this.urlToImage,
      this.title, this.author, this.date,
      this.desc, this.themeNames,
      {this.content = ""});

  News.fromJson(Map<String, dynamic> json):
      id = null,
      url = json["url"],
      title = htmlUnescape.convert(json["title"]),
      urlToImage = json["urlToImage"],
      author = json["author"],
      date = json["date"],
      desc = htmlUnescape.convert(json["desc"]);

}
