import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import '../models/trend_model.dart';

class FunctionProvider with ChangeNotifier {
  bool isLoading = true;
  String podcastName = '';
  String podcastImage = '';

  // changePodcastNameImage(String newName, String newImage) {
  //   podcastName = newName;
  //   podcastImage = newImage;
  //   notifyListeners();
  // }

  // Chunk function
  List<List<Feed>> chunk(List<Feed> list, int chunks) {
    List<List<Feed>> chunked = [];
    int vectLength = list.length;
    int steps = (vectLength / chunks).floor();
    int start = 0;
    int rem = vectLength - steps * chunks;
    int nextIndex = vectLength - rem;

    for (int i = 0; i < steps; i++) {
      var temp = list.getRange(start, start + chunks);
      start = start + chunks; //4
      chunked.add(temp.toList());
    }

    if (rem > 0) {
      List<Feed> left = [];
      for (int i = nextIndex; i < vectLength; i++) {
        left.add(list[i]);
      }
      chunked.add(left);
    }

    return chunked;
  }

  Future loadImages(List<Feed> someTrend, context) async {
    isLoading = true;

    await Future.wait(
        someTrend.map((e) => cacheImage(context, e.image)).toList());

    isLoading = false;
    notifyListeners();
    print('done');
  }

  Future cacheImage(context, url) => precacheImage(
        CachedNetworkImageProvider(url, maxWidth: 120),
        context,
      );
//  --------------Audio helpers

  // Future<void> initAudio(AudioPlayer player, String podcastUrl) async {
  //   final session = await AudioSession.instance;
  //   await session.configure(AudioSessionConfiguration.speech());
  //   player.playbackEventStream.listen((event) {},
  //       onError: (Object e, StackTrace stackTrace) {
  //     print('A stream eerror ocurred: $e');
  //   });
  //   // Try to load audio from a source and catch any errors.
  //   try {
  //     await player.setAudioSource(AudioSource.uri(Uri.parse(podcastUrl)));
  //   } catch (e) {
  //     print('Error loading audiosource');
  //   }
  // }
}
