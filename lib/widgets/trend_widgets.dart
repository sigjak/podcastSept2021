import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/trend_model.dart';
import '../screens/episode_page.dart';
import '../services/episodes_service.dart';

class EpisodeWidget extends StatelessWidget {
  const EpisodeWidget({
    required this.epis,
  });

  final EpisodeProvider epis;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: epis.items.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Episodes',
                  style: TextStyle(
                      fontFamily: 'MonteCarlo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
                CachedNetworkImage(
                  imageUrl: epis.podcastImage,
                  width: 30,
                ),
              ]),
            );
          }
          index--;
          return Padding(
            padding: const EdgeInsets.fromLTRB(32, 4, 32, 4),
            child: Container(
              height: 100,
              child: Card(
                color: Colors.grey[700],
                elevation: 5,
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onDoubleTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Episodes(index)));
                    },
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.fromLTRB(16, 2, 0, 2),
                      title: RichText(
                        text: TextSpan(
                            // style: TextStyle(color: Colors.black),
                            text: epis.items[index].title,
                            children: <TextSpan>[
                              TextSpan(
                                  style: TextStyle(fontSize: 9),
                                  text:
                                      '  ${epis.items[index].datePublishedPretty}')
                            ]),
                      ),
                      subtitle: Text(Bidi.stripHtmlIfNeeded(
                          epis.items[index].description!)),
                      // trailing: IconButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => Episodes(index)),
                      //     );
                      //   },
                      //   icon: Icon(Icons.play_arrow),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class TrendWidget extends StatelessWidget {
  const TrendWidget({
    required this.trendText,
    //required this.scrollController,
    required this.displayTrends,
  });
  final String trendText;
  //final ScrollController scrollController;
  final List<Feed> displayTrends;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.only(left: 16),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trendText,
            style: TextStyle(
                fontFamily: 'MonteCarlo',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RowWidget(
                // scrollController: scrollController,
                displayTrends: displayTrends),
          ),
        ],
      ),
    );
  }
}

class RowWidget extends StatefulWidget {
  const RowWidget({
    // required this.scrollController,
    required this.displayTrends,
  });

  //final ScrollController scrollController;
  final List<Feed> displayTrends;

  @override
  _RowWidgetState createState() => _RowWidgetState();
}

class _RowWidgetState extends State<RowWidget> {
  @override
  void initState() {
    super.initState();
  }

  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    final epis = context.read<EpisodeProvider>();

    return Row(
      children: [
        Expanded(
          child: ListView.builder(
              // controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.displayTrends.length,
              itemBuilder: (context, index) {
                final displayTrend = widget.displayTrends[index];
                return Container(
                  // width: 150,
                  // height: 150,
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: isSelected == index
                            ? BorderRadius.circular(50)
                            : BorderRadius.circular(10),
                        child: GestureDetector(
                          onDoubleTap: () async {
                            setState(() {
                              isSelected = index;
                              epis.podcastName = displayTrend.title!;
                              epis.podcastImage = displayTrend.image!;
                            });
                            // func.changePodcastNameImage(
                            //     displayTrend.title!, displayTrend.image!);
                            await epis.getEpisodes(displayTrend.id!);
                          },
                          child: CachedNetworkImage(
                            imageUrl: displayTrend.image!,
                            maxWidthDiskCache: 110,
                            maxHeightDiskCache: 110,
                            fadeInCurve: Curves.easeIn,
                            // color: Colors.grey,
                            // colorBlendMode: BlendMode.saturation,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/dd.png'),
                          ),
                        ),
                        //   child: Image.network(
                        //     displayTrend.image!,
                        //     width: 120,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        // child: FadeInImage.memoryNetwork(
                        //   placeholder: kTransparentImage,
                        //   image: displayTrend.image!,
                        //   width: 120,
                        //   imageCacheWidth: 120,
                        //   imageCacheHeight: 120,
                        //   fit: BoxFit.cover,
                        //   imageErrorBuilder: (context, error, stackTrace) {
                        //     return Image.asset(
                        //       'assets/images/dd.png',
                        //     );
                        //   },
                        // ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          displayTrend.title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
