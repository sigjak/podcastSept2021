import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/podindex.dart';
import '../models/podcast_model.dart';

class PodcastProvider with ChangeNotifier {
  List<Feed>? podcastList;

  Future<void> getPodcasts(String searchTerm) async {
    var baseUrl = 'https://api.podcastindex.org/api/1.0/search/byterm?q=';
    var url = Uri.parse(baseUrl + searchTerm);
    var headers = prepHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var podcasts = podcastsFromJson(response.body);
      podcastList = podcasts.feeds;
      print(podcastList![0].title);
    } else {
      print(response.statusCode);
    }
    notifyListeners();
  }
}
