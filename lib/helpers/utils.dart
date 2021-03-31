import 'dart:io';

import 'package:hi_news/resources/constants.dart';
import 'package:hi_news/resources/strings.dart';
import 'package:url_launcher/url_launcher.dart';

const THREE_DOTS = "...";
const SPACE = " ";
const SEPARATORS = ['.', ',', ';', ':'];

const GOOGLE_COM = "google.com";

String truncateSmart(String str, int count) {
  var words = str.split(" ");
  var result = StringBuffer();
  for (int i = 0; i < words.length; i++) {
    if (result.length >= count) {
      break;
    }
    result.write(words[i] + SPACE);
  }

  var unitedString = result.toString().trim();
  int lastIndex = unitedString.length - 1;
  if (SEPARATORS.contains(unitedString[lastIndex])) {
    unitedString = unitedString.substring(0, lastIndex);
  }

  return unitedString + THREE_DOTS;
}

bool isMatchString(String source, String matching) {
  return source.toLowerCase() == matching.toLowerCase();
}

bool isContainString(String source, String contained) {
  if (contained.trim().isEmpty) {
    return true;
  }
  return source.toLowerCase().contains(contained.toLowerCase());
}

Future<bool> checkConnectivity() async {
  try {
    final result = await InternetAddress.lookup(GOOGLE_COM);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
  );

  return htmlText.replaceAll(exp, '');
}

String getDateNow() {
  final now = DateTime.now();
  return "${now.day} ${Constants.months[now.month - 1]} ${now.year} г";
}

String checkFieldEmpty(String text) {
  return text.trim().isEmpty
      ? Strings.shouldNotFieldEmpty
      : null;
}

String joinList(List<String> themeNames) {
  String themeNamesStr = "";
  if (themeNames.length == 1 && themeNames.first != Strings.everything) {
    themeNamesStr = themeNames.first;
  }
  if (themeNames.length > 1) {
    themeNamesStr = themeNames.join(",");
  }
  return themeNamesStr;
}

bool isListContainElementsAnyList(List<dynamic> source, List<dynamic> destination) {

  for (int i = 0; i < source.length; i++) {
    if (destination.contains(source[i])) {
      return true;
    }
  }

  return false;
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}