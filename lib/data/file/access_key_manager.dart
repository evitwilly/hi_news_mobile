
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/access_key.dart';


class AccessKeyManager {

  static Future<AccessKey> getAccessKey() async {
    String json = await rootBundle.loadString("json/access_key.json");
    return AccessKey.fromJson(jsonDecode(json));
  }

}
