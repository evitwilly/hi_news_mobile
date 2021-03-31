
import 'package:hi_news/domain/news.dart';

abstract class ContentResponseStatus {
  final News oneNews;

  ContentResponseStatus(this.oneNews);
}

class StandardContentStatus extends ContentResponseStatus {
  StandardContentStatus(News oneNews): super(oneNews);
}

class ErrorContentStatus extends ContentResponseStatus {
  ErrorContentStatus(News oneNews) : super(oneNews);
}

class NoExistsContentStatus extends ContentResponseStatus {
  NoExistsContentStatus(): super(null);
}