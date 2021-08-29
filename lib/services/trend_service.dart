import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/trend_model.dart';
import '../providers/podindex.dart';

class TrendProvider with ChangeNotifier {
  List<Feed>? trendList;

  Future<void> getTrends(String searchTerm) async {
    var baseUrl =
        'https://api.podcastindex.org/api/1.0/podcasts/trending?since=-10000000&max=20&notcat=65,86&';
    var url = Uri.parse(baseUrl + searchTerm);
    var headers = prepHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var trends = trendingFromJson(response.body);
      trendList = trends.feeds;
      //print(trendList![0].author);

      // print(response.statusCode);
    } else {
      print(response.statusCode);
      throw Exception('Failed to load album');
    }
    notifyListeners();
  }
}
