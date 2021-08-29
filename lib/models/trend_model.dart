// To parse this JSON data, do
//
//     final trending = trendingFromJson(jsonString);

import 'dart:convert';

Trending trendingFromJson(String str) => Trending.fromJson(json.decode(str));

String trendingToJson(Trending data) => json.encode(data.toJson());

class Trending {
  Trending({
    this.status,
    this.feeds,
    this.count,
    this.max,
    this.since,
    this.description,
  });

  String? status;
  List<Feed>? feeds;
  int? count;
  int? max;
  int? since;
  String? description;

  factory Trending.fromJson(Map<String, dynamic> json) => Trending(
        status: json['status'],
        feeds: List<Feed>.from(json['feeds'].map((x) => Feed.fromJson(x))),
        count: json['count'],
        max: json['max'],
        since: json['since'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'feeds': List<dynamic>.from(feeds!.map((x) => x.toJson())),
        'count': count,
        'max': max,
        'since': since,
        'description': description,
      };
}

class Feed {
  Feed({
    this.id,
    this.url,
    this.title,
    this.author,
    this.image,
    this.newestItemPublishedTime,
    this.itunesId,
    this.trendScore,
    this.language,
    this.categories,
  });

  int? id;
  String? url;
  String? title;
  String? author;
  String? image;
  int? newestItemPublishedTime;
  int? itunesId;
  int? trendScore;
  String? language;
  Map<String, String>? categories;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        id: json['id'],
        url: json['url'],
        title: json['title'],
        author: json['author'],
        image: json['image'],
        newestItemPublishedTime: json['newestItemPublishedTime'],
        itunesId: json['itunesId'],
        trendScore: json['trendScore'],
        language: json['language'],
        categories: Map.from(json['categories'])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'title': title,
        'author': author,
        'image': image,
        'newestItemPublishedTime': newestItemPublishedTime,
        'itunesId': itunesId,
        'trendScore': trendScore,
        'language': language,
        'categories': Map.from(categories!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
