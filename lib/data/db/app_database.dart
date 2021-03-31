import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:hi_news/domain/news.dart';
import 'news_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [News])
abstract class AppDatabase extends FloorDatabase {
  NewsDao get newsDao;
}