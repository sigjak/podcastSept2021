// To parse this JSON data, do
//
//     final podcasts = podcastsFromJson(jsonString);

import 'dart:convert';

Podcasts podcastsFromJson(String str) => Podcasts.fromJson(json.decode(str));

String podcastsToJson(Podcasts data) => json.encode(data.toJson());

class Podcasts {
  Podcasts({
    this.status,
    this.feeds,
  });

  String? status;
  List<Feed>? feeds;

  factory Podcasts.fromJson(Map<String, dynamic> json) => Podcasts(
        status: json['status'],
        feeds: List<Feed>.from(json['feeds'].map((x) => Feed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'feeds': List<dynamic>.from(feeds!.map((x) => x.toJson())),
      };
}

class Feed {
  Feed({
    this.title,
    this.description,
    this.image,
    this.itunesId,
  });

  String? title;
  String? description;
  String? image;
  int? itunesId;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        title: json['title'],
        description: json['description'],
        image: json['image'],
        itunesId: json['itunesId'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'image': image,
        'itunesId': itunesId,
      };
}

//Fresh Air: {1: Arts, 2: Books, 104: Tv, 105: Film, 77: Society, 78: Culture}
