

import 'package:hi_news/domain/news.dart';

abstract class PageResponseStatus {
  final List<News> news;

  PageResponseStatus(this.news);
}

class StandardPageStatus extends PageResponseStatus {
  StandardPageStatus(List<News> news): super(news);
}

class LastPageStatus extends PageResponseStatus {
  LastPageStatus(List<News> news): super(news);
}

class NoExistsPageStatus extends PageResponseStatus {
  NoExistsPageStatus(): super(<News>[]);
}