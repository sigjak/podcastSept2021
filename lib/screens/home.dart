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
  List<Feed> categoryTrends = [];
  List<String> categoryList = [
    'News',
    'Comedy',
    'Daily',
    'Art',
    'Books',
    'Interviews'
  ];
  List<String> categoryNumbers = ['55', '16', '56', '1', '2', '17'];
  List<bool> selectionList = [true, false, false, false, false, false];
  String? trendName;

  @override
  void initState() {
    getNew('55', 'News');
    super.initState();
  }

  Future<void> getNew(String dat, String name) async {
    var data = context.read<TrendProvider>();
    var func = context.read<FunctionProvider>();
    var epis = context.read<EpisodeProvider>();

    await data.getTrends('lang=en&cat=$dat').then((_) {
      setState(() {
        trendName = name;
        trends = data.trendList!;
        epis.podcastName = trends[0].title!;
        epis.podcastImage = trends[0].image!;
        epis.getEpisodes(trends[0].id!);
        categoryTrends = trends.getRange(0, 5).toList();
        func.loadImages(categoryTrends, context);
        categoryTrends = [...trends];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final funcTwo = context.watch<FunctionProvider>();
    final epis = context.watch<EpisodeProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
            child: ToggleButtons(
              color: Colors.white,
              splashColor: Colors.white,
              selectedColor: Colors.white,
              selectedBorderColor: Colors.grey.shade300,
              children: categoryList
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(item),
                      ))
                  .toList(),
              isSelected: selectionList,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < selectionList.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      selectionList[buttonIndex] = true;
                      getNew(categoryNumbers[buttonIndex],
                          categoryList[buttonIndex]);
                    } else {
                      selectionList[buttonIndex] = false;
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
      body: funcTwo.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TrendWidget(
                    trendText: trendName!, displayTrends: categoryTrends),
                Text(
                  epis.podcastName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'MonteCarlo', fontSize: 24),
                ),
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
