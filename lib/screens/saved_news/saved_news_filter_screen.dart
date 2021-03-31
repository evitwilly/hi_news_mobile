import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hi_news/data/preferences.dart';
import 'package:hi_news/data/static/authors.dart';
import 'package:hi_news/data/static/themes.dart';
import 'package:hi_news/domain/news_filter.dart';
import 'package:hi_news/helpers/utils.dart';
import 'package:hi_news/widgets/filter_title.dart';
import 'package:hi_news/widgets/list_authors.dart';
import 'package:hi_news/widgets/list_themes.dart';
import 'package:hi_news/widgets/selected_authors.dart';
import '../../resources/strings.dart';
import 'widgets/selected_some_themes.dart';

class SavedNewsFilterScreen extends StatefulWidget {
  @override
  _SavedNewsFilterState createState() => _SavedNewsFilterState();
}

class _SavedNewsFilterState extends State<SavedNewsFilterScreen> {

  List<String> selectedThemeNames = [];
  List<String> selectedAuthorNames = [];
  List<String> themeNames = [Strings.everything] + Themes.themes.map((e) => e.name).toList();
  List<String> authorNames = [Strings.everything] + Authors.authors.map((e) => e.name).toList();

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
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterTitle(Strings.selectNewsTheme),
        _buildSearchFieldTheme(),
        ListThemes(themeNames, selectedThemeNames, _updateSelectedThemes),
        SelectedSomeThemes(selectedThemeNames),
        FilterTitle(Strings.selectAuthor),
        _buildSearchFieldAuthor(),
        ListAuthors(authorNames, selectedAuthorNames, _updateSelectedAuthors),
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

  void _updateSelectedThemes(bool isSelected, int index) {
    setState(() {
      if (!isSelected) {
        if (themeNames[index] == Strings.everything) {
          selectedThemeNames = [];
        } else {
          if (selectedThemeNames.contains(Strings.everything)) {
            selectedThemeNames.remove(Strings.everything);
          }
          selectedThemeNames.add(themeNames[index]);
        }
      } else {
        if (themeNames[index] != Strings.everything) {
          selectedThemeNames.remove(themeNames[index]);
        }
      }
    });
  }

  void _updateSelectedAuthors(bool isSelected, int index) {
    setState(() {
      if (!isSelected) {
        if (authorNames[index] == Strings.everything) {
          selectedAuthorNames = [];
        } else {
          if (selectedAuthorNames.contains(Strings.everything)) {
            selectedAuthorNames.remove(Strings.everything);
          }
          selectedAuthorNames.add(authorNames[index]);
        }
      } else {
        if (authorNames[index] != Strings.everything) {
          selectedAuthorNames.remove(authorNames[index]);
        }
      }
    });
  }

  void _filterThemeByName(String filterThemeName) async {
    final filteredThemes = Themes.themes.map((e) => e.name).where((themeName) {
      return isContainString(themeName, filterThemeName);
    }).toList();

    filteredThemes.sort((oneThemeName, twoThemeName) {
      return oneThemeName.compareTo(twoThemeName);
    });

    setState(() {
      themeNames = filteredThemes;
    });
  }

  Future<void> _filterAuthorByName(String filterAuthorName) async {

    final filteredAuthors = Authors.authors.map((e) => e.name).where((authorName) {
      return isContainString(authorName, filterAuthorName);
    }).toList();

    filteredAuthors.sort((oneAuthorName, twoAuthorName) {
      return oneAuthorName.compareTo(twoAuthorName);
    });

    setState(() {
      authorNames = filteredAuthors;
    });
  }

  void _getSavedFilter() async {
    final filter = await Preferences.getSavedNewsFilter();

    setState(() {
      selectedThemeNames = filter.themeNames;
      selectedAuthorNames = filter.authorNames;
    });
  }

  Future<void> _applyFilter() async {
    final filter = SavedNewsFilter(selectedThemeNames, selectedAuthorNames);
    await Preferences.saveSavedNewsFilter(filter);
    Navigator.of(context).pop(filter);
  }
}
