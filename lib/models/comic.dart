import 'package:objectbox/objectbox.dart';

@Entity()
class Comic {
  int id = 0;

  Comic({
    required this.month,
    required this.number,
    required this.link,
    required this.year,
    required this.news,
    required this.safeTitle,
    required this.transcript,
    required this.alt,
    required this.imageUrl,
    required this.title,
    required this.day,
  });

  late final String month;
  late final int number;
  late final String link;
  late final String year;
  late final String news;
  late final String safeTitle;
  late final String transcript;
  late final String alt;
  late final String imageUrl;
  late final String title;
  late final String day;

  Comic.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    number = json['num'];
    link = json['link'];
    year = json['year'];
    news = json['news'];
    safeTitle = json['safe_title'];
    transcript = json['transcript'];
    alt = json['alt'];
    imageUrl = json['img'];
    title = json['title'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['month'] = month;
    data['num'] = number;
    data['link'] = link;
    data['year'] = year;
    data['news'] = news;
    data['safe_title'] = safeTitle;
    data['transcript'] = transcript;
    data['alt'] = alt;
    data['img'] = imageUrl;
    data['title'] = title;
    data['day'] = day;
    return data;
  }
}
