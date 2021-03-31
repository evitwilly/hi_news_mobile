import 'dart:convert';
import 'dart:io';
import 'package:hi_news/data/status/content_response_status.dart';
import 'package:hi_news/domain/news.dart';
import 'package:hi_news/domain/news_filter.dart';
import 'package:hi_news/domain/review.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:hi_news/resources/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'db/app_database.dart';
import 'db/news_dao.dart';
import 'file/access_key_manager.dart';
import 'status/response_status.dart';

class DataItem {}

class NewsItem extends DataItem {
  NewsItem(this.news);

  final News news;
}

class FooterItem extends DataItem {}

class Repository {

  static const SUCCESS = "success";
  static const NO_EXISTS_PAGE = "no_exists";
  static const LAST_PAGE = "last_page";

  NewsDao newsDao;

  final uuid = Uuid();

  Future<void> initDatabase() async {
    if (newsDao == null) {
      final database = await $FloorAppDatabase.databaseBuilder("app_database.db").build();
      newsDao = database.newsDao;
    }
  }

  Future<Map<String, dynamic>> getJson(String requestUrl) async {
    http.Response response = await http.get(requestUrl).timeout(Duration(seconds: Constants.TIMEOUT), onTimeout: () {
      throw Exception("Internet is very slow!");
    });
    return jsonDecode(response.body);
  }


  Future<PageResponseStatus> _makeRequestNews(String requestUrl) async {
    final json = await getJson(requestUrl);

    checkStatus(json["status"]);

    var data = json["data"];

    if (data["page_status"] == NO_EXISTS_PAGE) {
      return NoExistsPageStatus();
    }

    final jsonNews = data["news"] as List;
    final news = jsonNews.map<News>((json) => News.fromJson(json)).toList();

    if (data["page_status"] == LAST_PAGE) {
      return LastPageStatus(news);
    }

    return StandardPageStatus(news);
  }

  Future<PageResponseStatus> loadNews(String themeId, int page) async {
    var accessKey = await AccessKeyManager.getAccessKey();

    var requestUrl = "https://rubteh.ru/rub2time/"
        "get_news.php?theme=$themeId"
        "&access_key=${accessKey.key}&page=$page";

    return await _makeRequestNews(requestUrl);
  }

  Future<PageResponseStatus> searchNews(String searchPattern, int page) async {
    var accessKey = await AccessKeyManager.getAccessKey();

    var requestUrl = "https://rubteh.ru/rub2time/"
        "search.php?query=${searchPattern == null || searchPattern.isEmpty ? "\"\"" : searchPattern}"
        "&access_key=${accessKey.key}&page=$page";

    return await _makeRequestNews(requestUrl);
  }

  Future<ContentResponseStatus> updateNews(News oneNews) async {
    var accessKey = await AccessKeyManager.getAccessKey();

    var requestUrl = "https://rubteh.ru/rub2time/"
        "get_content.php?access_key=${accessKey.key}"
        "&link=${oneNews.url}";

    try {

      final json = await getJson(requestUrl);

      checkStatus(json["status"]);

      final data = json['data'];

      if (data["content_status"] == NO_EXISTS_PAGE) {
        return NoExistsContentStatus();
      } else {
        oneNews.content = jsonEncode(data['content']);
      }
      final themes = data['themes'] as List;

      oneNews.themeNames = themes.join(",");

      return StandardContentStatus(oneNews);

    } catch (exception) {
      return ErrorContentStatus(oneNews);
    }
  }

  Future<void> delete(int newsId) async {
    await initDatabase();
    await newsDao.delete(newsId);
  }

  Future<String> downloadImage(String appDirectoryPath, String imageUrl) async {
    final response = await http.get(imageUrl);

    final imageId = join(appDirectoryPath, uuid.v4());

    final file = File(imageId);
    file.writeAsBytesSync(response.bodyBytes);

    return imageId;
  }

  Future<void> insert(News oneNews) async {
    await initDatabase();

    final appDirectory = await getApplicationDocumentsDirectory();

    oneNews.urlToImage = await downloadImage(appDirectory.path, oneNews.urlToImage);

    final List<dynamic> newContent = [];

    final content = jsonDecode(oneNews.content) as List<dynamic>;

    for (int i = 0; i < content.length; i++) {
      final element = content[i];
      if (element['type'] == 'image') {
        final imageUrl = element['img'];
        element['img'] = await downloadImage(appDirectory.path, imageUrl);
        newContent.add(element);
      } else {
        newContent.add(element);
      }
    }

    oneNews.content = jsonEncode(newContent);
    await newsDao.insertOne(oneNews);
  }

  Future<List<News>> getAllSavedNews() async {
    await initDatabase();
    return await newsDao.getAll();
  }

  Future<List<News>> getFilteredSavedNews(SavedNewsFilter filter) async {
    final themeNames = filter.themeNames;
    final authorNames = filter.authorNames;
    var allNews = await getAllSavedNews();
    if (themeNames.length > 0) {
      allNews = allNews.where((oneNews) {
        bool isList = isListContainElementsAnyList(oneNews.themeNames.split(","), themeNames);
        return isList;
      }).toList();
    }
    if (authorNames.length > 0) {
      allNews = allNews.where((oneNews) {
        return authorNames.contains(oneNews.author.trim());
      }).toList();
    }

    return allNews;
  }

  Future<List<News>> getSavedNewsByThemeId(String themeId) async {
    await initDatabase();
    return await newsDao.getNewsByThemeId(themeId);
  }

  void checkStatus(String status) {
    if (status != SUCCESS) {
      throw Exception("Failed status");
    }
  }

}
