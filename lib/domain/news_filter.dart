class SavedNewsFilter {
  final List<String> authorNames;
  final List<String> themeNames;

  SavedNewsFilter(this.themeNames, this.authorNames);
}

class NetworkNewsFilter {
  final List<String> authorNames;
  final String themeId;

  NetworkNewsFilter(this.themeId, this.authorNames);
}