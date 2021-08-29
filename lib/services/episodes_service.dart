import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/episode_model.dart';
import '../providers/podindex.dart';

class EpisodeProvider with ChangeNotifier {
  List<Item> items = [];
  String podcastName = '';
  String podcastImage = '';

  Future<void> getEpisodes(int feedID) async {
    var baseUrl =
        'https://api.podcastindex.org/api/1.0/episodes/byfeedid?max=10&id=';
    var url = Uri.parse(baseUrl + feedID.toString());
    var headers = prepHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var episodes = episodesFromJson(response.body);
      items = episodes.items!;

      // print(items[0].description);
      // print('Title. ${items[0].title}');
      // print(items[0].enclosureUrl);
      // print(items[0].enclosureType);
      // print(items[0].image);
      // print(items[0].feedImage);
      // print(items[0].guid);
      // print(items[0].datePublished);

      notifyListeners();
      print(items.length);
    } else {
      print('Error');
    }
  }
}
