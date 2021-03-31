import 'package:hi_news/helpers/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/news_filter.dart';
import 'static/themes.dart';

class Preferences {

  static const IS_DARK_THEME = "DARK_THEME";

  static const SAVED_NEWS_THEME_NAMES = "saved_news_theme_names";
  static const NETWORK_NEWS_THEME_ID = "network_news_theme_id";

  static const SAVED_NEWS_AUTHOR_NAMES = "saved_news_author_names";
  static const NETWORK_NEWS_AUTHOR_NAMES = "network_news_author_names";

  static SharedPreferences _preferences;

  static final emptyList = <String>[];

  static Future<void> initPrefs() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  static Future<bool> isDark() async {
    await initPrefs();
    return _preferences.getBool(IS_DARK_THEME) == null
        ? false
        : _preferences.getBool(IS_DARK_THEME);
  }

  static void switchDark(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_DARK_THEME, isDark);
  }
  static Future<void> saveNetworkNewsFilter(NetworkNewsFilter filter) async {
    await initPrefs();
    _preferences.setString(NETWORK_NEWS_THEME_ID, filter.themeId);
    _preferences.setString(NETWORK_NEWS_AUTHOR_NAMES, filter.authorNames.join(","));
  }

  static Future<void> saveSavedNewsFilter(SavedNewsFilter filter) async {
    await initPrefs();
    _preferences.setString(SAVED_NEWS_THEME_NAMES, joinList(filter.themeNames));
    _preferences.setString(SAVED_NEWS_AUTHOR_NAMES, joinList(filter.authorNames));
  }



  static List<String> _getAuthorNames(String key) {
    final authorNames = _preferences.getString(key);

    final authorNamesList = authorNames == null || authorNames.length <= 0
        ? <String>[]
        : authorNames.split(",");

    return authorNamesList;
  }

  static Future<SavedNewsFilter> getSavedNewsFilter() async {
    await initPrefs();

    final  themeNames = _preferences.getString(SAVED_NEWS_THEME_NAMES);

    final themeNamesList = themeNames == null || themeNames.length <= 0
        ? <String>[] : themeNames.split(",");

    final authorNamesList = _getAuthorNames(SAVED_NEWS_AUTHOR_NAMES);

    return SavedNewsFilter(themeNamesList, authorNamesList);
  }
  
  static Future<NetworkNewsFilter> getNetworkNewsFilter() async {
    await initPrefs();

    final  themeId = _preferences.getString(NETWORK_NEWS_THEME_ID);

    final themeIdValue = themeId == null ? Themes.themes[0].id : themeId;

    final authorNamesList = _getAuthorNames(NETWORK_NEWS_AUTHOR_NAMES);

    return NetworkNewsFilter(themeIdValue, authorNamesList);
  }

}