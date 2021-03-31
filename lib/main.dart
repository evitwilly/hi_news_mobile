import 'package:flutter/material.dart';
import 'data/preferences.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await Preferences.isDark();
  runApp(MyApp(isDark: isDark));
}


