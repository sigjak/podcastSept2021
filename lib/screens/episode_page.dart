import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcasts/audio/slider_bar.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '/audio/player_buttons.dart';
import '/services/episodes_service.dart';
import '/audio/slider_bar.dart';

class Episodes extends StatefulWidget {
  Episodes(this.index);
  final int index;
  static const routeName = '/episodes';

  @override
  _EpisodesState createState() => _EpisodesState();
}

class _EpisodesState extends State<Episodes> with WidgetsBindingObserver {
  ScrollController _scrollController = ScrollController();
  int? isSelected;
  final _audioPlayer = AudioPlayer();
  String episodeName = '';
  late LockCachingAudioSource _audioSource;

  @override
  void initState() {
    final epi = context.read<EpisodeProvider>();
    episodeName = epi.items[widget.index].title!;
    super.initState();
    isSelected = widget.index;
    WidgetsBinding.instance?.addObserver(this);
    _initAudio(
        epi.items[widget.index].enclosureUrl!, epi.items[widget.index].title!);
  }

  Future<void> _initAudio(String podcastUrl, String title) async {
    _audioSource = LockCachingAudioSource(Uri.parse(podcastUrl));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream eerror ocurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      AudioSource audioSource = AudioSource.uri(Uri.parse(podcastUrl),
          tag: MediaItem(id: '1', title: title));
      await _audioPlayer.setAudioSource(audioSource);
      _audioPlayer.play();
    } catch (e) {
      print('Error loading audiosource');
    }
  }

  // Future<void> initAudio(String podcastUrl) async {
  //   final session = await AudioSession.instance;
  //   await session.configure(AudioSessionConfiguration.speech());
  //   _audioPlayer.playbackEventStream.listen((event) {},
  //       onError: (Object e, StackTrace stackTrace) {
  //     print('A stream eerror ocurred: $e');
  //   });
  //   // Try to load audio from a source and catch any errors.
  //   try {
  //     await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(podcastUrl)));
  //     _audioPlayer.play();
  //   } catch (e) {
  //     print('Error loading audiosource');
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _audioPlayer.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, double, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioSource.downloadProgressStream,
          _audioPlayer.durationStream,
          (position, downloadProgress, reportedDuration) {
        final duration = reportedDuration ?? Duration.zero;
        final bufferedPosition = duration * downloadProgress;
        if (position > duration) position = Duration.zero;
        return PositionData(position, bufferedPosition, duration);
      });

  @override
  Widget build(BuildContext context) {
    final epis = context.read<EpisodeProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: CustomScrollView(controller: _scrollController, slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[850],
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: epis.podcastImage,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      episodeName,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center, //
                      style: TextStyle(
                        fontFamily: 'MonteCarlo',
                        fontSize: 24,
                      ),
                    ),
                  ),
                  PlayerButtons(_audioPlayer),
                  StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return SliderBar(
                            audioPlayer: _audioPlayer,
                            duration: positionData?.duration ?? Duration.zero,
                            position: positionData?.position ?? Duration.zero,
                            bufferedPosition: positionData?.bufferedPosition ??
                                Duration.zero);
                        // return SeekBar(
                        //   duration: positionData?.duration ?? Duration.zero,
                        //   position: positionData?.position ?? Duration.zero,
                        //   bufferedPosition:
                        //       positionData?.bufferedPosition ?? Duration.zero,
                        //   onChanged: _audioPlayer.seek,
                        // );
                      })
                  //SliderBar(_audioPlayer),
                ],
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 100.0,
            delegate: SliverChildBuilderDelegate(
              (context, podIndex) {
                final episode = epis.items[podIndex];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(32, 4, 32, 4),
                  child: Container(
                    decoration: isSelected == podIndex
                        ? BoxDecoration(
                            border: Border.all(width: 1.0),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    height: 100,
                    child: Card(
                      color: Colors.grey.shade600,
                      elevation: 5,
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          onDoubleTap: () async {
                            _scrollController.animateTo(0,
                                duration: Duration(seconds: 2),
                                curve: Curves.easeInOutSine);
                            setState(() {
                              _audioPlayer.stop();
                              // _audioPlayer.play();
                              isSelected = podIndex;
                              episodeName = episode.title!;
                            });
                            await _initAudio(
                                episode.enclosureUrl!, episode.title!);
                          },
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.fromLTRB(16, 2, 0, 2),
                            title: Text(episode.title!),
                            subtitle: Text(
                              Bidi.stripHtmlIfNeeded(episode.description!),
                              style: TextStyle(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: epis.items.length,
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.exit_to_app),
          onPressed: () {
            dispose();
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }),
    );
  }
}
