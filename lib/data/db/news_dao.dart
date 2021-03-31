import 'package:floor/floor.dart';
import 'package:hi_news/domain/news.dart';

@dao
abstract class NewsDao {

  @Query("select * from news where themeId like :themeId")
  Future<List<News>> getNewsByThemeId(String themeId);

  @Query("select * from news")
  Future<List<News>> getAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOne(News news);

  @Query("delete from news where id = :newsId")
  Future<void> delete(int newsId);

}