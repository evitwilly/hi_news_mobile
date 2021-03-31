import 'dart:collection';

class Review {
  int id;
  String name;
  String date;
  double rating;
  String text;

  Review(
      this.name,
      this.date,
      this.rating,
      this.text);

  Review.fromJson(LinkedHashMap<dynamic, dynamic> json, int id):
        this.id = id,
        this.name = json['name'] as String,
        this.date = json['date'] as String,
        this.rating = (json['rating'] as num)?.toDouble(),
        this.text = json['text'] as String;

  Map<String, dynamic> toJson() => {
    "name": this.name,
    "date": this.date,
    "rating": this.rating,
    "text": this.text,
  };

}