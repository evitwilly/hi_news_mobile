class AccessKey {
  final String key;

  const AccessKey(this.key);

  AccessKey.fromJson(Map<String, dynamic> json):
        key = json["key"];

}