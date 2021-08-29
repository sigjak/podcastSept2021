import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/functions.dart';
import '/services/trend_service.dart';
import '/services/episodes_service.dart';
import '../models/trend_model.dart';
import '../widgets/trend_widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Feed> trends = [];
  List<Feed> newsTrends = [];
  // List<List<Feed>> chunkedNews = [];
  int loadNews = 0;
  String podcastName = '';

  // ScrollController newsScrollController = ScrollController();

  @override
  void initState() {
    var data = context.read<TrendProvider>();
    var func = context.read<FunctionProvider>();
    var epis = context.read<EpisodeProvider>();

    data.getTrends('lang=en&cat=57').then((_) {
      setState(() {
        trends = data.trendList!;

        // func.changePodcastNameImage(trends[0].title!, trends[0].image!);
        //chunkedNews = func.chunk(trends, 5);
        epis.podcastName = trends[0].title!;
        epis.podcastImage = trends[0].image!;
        epis.getEpisodes(trends[0].id!);
        newsTrends = trends.getRange(0, 5).toList();
        //newsTrends = [...trends];
        // loadMoreNews();
        func.loadImages(newsTrends, context);
        newsTrends = [...trends];

        // newsScrollController.addListener(() {
        //   if (newsScrollController.position.pixels >=
        //       newsScrollController.position.maxScrollExtent / 2) {
        //     loadMoreNews();
        //   }
        // });
      });
    });

    super.initState();
  }

  // loadMoreNews() {
  //   if (loadNews <= chunkedNews.length - 1) {
  //     newsTrends.addAll(chunkedNews[loadNews]);
  //     setState(() {
  //       loadNews++;
  //     });
  //   }
  // }

  @override
  void dispose() {
    //  newsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final funcTwo = context.watch<FunctionProvider>();
    final epis = context.watch<EpisodeProvider>();
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          epis.podcastName,
        ),
        centerTitle: true,
      ),
      body: funcTwo.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TrendWidget(
                    trendText: 'News',
                    // scrollController: newsScrollController,
                    displayTrends: newsTrends),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: EpisodeWidget(epis: epis),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
