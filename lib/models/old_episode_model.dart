// To parse this JSON data, do
//
//     final episodes = episodesFromJson(jsonString);

import 'dart:convert';

Episodes episodesFromJson(String str) => Episodes.fromJson(json.decode(str));

String episodesToJson(Episodes data) => json.encode(data.toJson());

class Episodes {
  Episodes({
    this.status,
    this.items,
    this.count,
    this.query,
    this.description,
  });

  String? status;
  List<Item>? items;
  int? count;
  String? query;
  String? description;

  factory Episodes.fromJson(Map<String, dynamic> json) => Episodes(
        status: json["status"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        count: json["count"],
        query: json["query"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
        "count": count,
        "query": query,
        "description": description,
      };
}

class Item {
  Item({
    this.id,
    this.title,
    this.description,
    this.datePublished,
    this.enclosureUrl,
    this.image,
  });

  int? id;
  String? title;
  String? description;
  int? datePublished;
  String? enclosureUrl;
  String? image;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        datePublished: json["datePublished"],
        enclosureUrl: json["enclosureUrl"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "datePublished": datePublished,
        "enclosureUrl": enclosureUrl,
        "image": image,
      };
}
