import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hi_news/data/preferences.dart';
import 'package:hi_news/data/static/authors.dart';
import 'package:hi_news/data/static/themes.dart';
import 'package:hi_news/domain/my_theme.dart';
import 'package:hi_news/domain/news_filter.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:hi_news/widgets/filter_title.dart';
import 'package:hi_news/widgets/list_authors.dart';
import 'package:hi_news/widgets/selected_authors.dart';
import 'package:hi_news/widgets/selected_theme.dart';
import '../../resources/strings.dart';
import 'widgets/list_themes_with_single_selection.dart';

class NetworkNewsFilterScreen extends StatefulWidget {
  @override
  _NetworkNewsFilterScreen createState() => _NetworkNewsFilterScreen();
}

class _NetworkNewsFilterScreen extends State<NetworkNewsFilterScreen> {

  List<NewsTheme> themes = Themes.themes;
  NewsTheme selectedTheme = Themes.themes[0];

  List<String> authors = [ Strings.everything ] + Authors.authors.map((e) => e.name).toList();
  List<String> selectedAuthorNames = [ Strings.everything ];

  final TextEditingController themeController = new TextEditingController();
  final TextEditingController authorController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSavedFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.filterNews), actions: [
        IconButton(
          icon: Icon(Icons.check),
          tooltip: Strings.applyFilter,
          onPressed: () {
            _applyFilter();
          },
        )
      ]),
      body: _buildFilters(),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterTitle(Strings.selectNewsTheme),
        _buildSearchFieldTheme(),
        ListThemesWithSingleSelection(themes, selectedTheme, (NewsTheme newTheme) {
          setState(() {
            selectedTheme = newTheme;
          });
        }),
        SelectedSingleTheme(selectedTheme.name),
        FilterTitle(Strings.selectAuthor),
        _buildSearchFieldAuthor(),
        ListAuthors(authors, selectedAuthorNames, _updateSelectedAuthors),
        SelectedAuthors(selectedAuthorNames),
      ],
    ));
  }

  Widget _buildSearchFieldTheme() {
    return Container(
      padding: EdgeInsets.only(left: 7, top: 7, right: 7),
      child: TextField(
        controller: themeController,
        onSubmitted: (text) {
          _filterThemeByName(text);
        },
        decoration: InputDecoration(
          hintText: Strings.searchHint,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _filterThemeByName(themeController.text);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFieldAuthor() {
    return Container(
      padding: EdgeInsets.only(left: 7, top: 7, right: 7),
      child: TextField(
        controller: authorController,
        onSubmitted: (text) {
          _filterAuthorByName(text);
        },
        decoration: InputDecoration(
          hintText: Strings.searchHint,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _filterAuthorByName(authorController.text);
            },
          ),
        ),
      ),
    );
  }

  void _updateSelectedAuthors(bool isSelected, int index) {
    setState(() {
      if (!isSelected) {
        if (authors[index] == Strings.everything) {
          selectedAuthorNames = [];
        } else {
          if (selectedAuthorNames.contains(Strings.everything)) {
            selectedAuthorNames.remove(Strings.everything);
          }
          selectedAuthorNames.add(authors[index]);
        }
      } else {
        if (authors[index] != Strings.everything) {
          selectedAuthorNames.remove(authors[index]);
        }
      }
    });
  }

  void _filterThemeByName(String themeName) async {

    final filteredThemes = Themes.themes.where((NewsTheme theme) {
      return isContainString(theme.name, themeName);
    }).toSet().toList();

    filteredThemes.sort((NewsTheme a, NewsTheme b) {
      return a.name.compareTo(b.name);
    });

    setState(() {
      themes = filteredThemes;
    });

  }

  Future<void> _filterAuthorByName(String filterAuthorName) async {

    final filteredAuthors = Authors.authors
        .map((e) => e.name)
        .where((authorName) {
          return isContainString(authorName, filterAuthorName);
        }).toList();

    filteredAuthors.sort((oneAuthorName, twoAuthorName) {
      return oneAuthorName.compareTo(twoAuthorName);
    });

    setState(() {
      authors = [ Strings.everything ] + filteredAuthors;
    });
  }

  void _getSavedFilter() async {
    final filter = await Preferences.getNetworkNewsFilter();
    final theme = Themes.getThemeById(filter.themeId);
    setState(() {
      selectedTheme = theme;
      selectedAuthorNames = filter.authorNames;
    });
  }

  Future<void> _applyFilter() async {
    final filter = NetworkNewsFilter(
        selectedTheme.id, selectedAuthorNames
    );
    await Preferences.saveNetworkNewsFilter(filter);
    Navigator.of(context).pop(filter);
  }
}
