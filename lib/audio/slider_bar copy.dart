import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SliderBar extends StatefulWidget {
  SliderBar(this._audioPlayer);
  final AudioPlayer _audioPlayer;
  @override
  _SliderBarState createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  String formatDur(Duration d) {
    return (d.toString().split('.').first.padLeft(7, '0'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<Duration?>(
            stream: widget._audioPlayer.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                  stream: widget._audioPlayer.positionStream,
                  builder: (context, snapshot2) {
                    var position = snapshot2.data ?? Duration.zero;
                    if (position > duration) {
                      position = Duration.zero;
                    }
                    return _positionSlider(duration, position);
                  });
            }),
      ],
    );
  }

  Widget _positionSlider(Duration duration, Duration position) {
    return Stack(children: [
      Slider(
          activeColor: Colors.grey[600],
          inactiveColor: Colors.grey[300],
          min: 0,
          max: duration.inMilliseconds.toDouble(),
          value: position.inMilliseconds.toDouble(),
          onChanged: (value) {
            setState(() {
              widget._audioPlayer.seek(Duration(milliseconds: value.round()));
            });
          }),
      Positioned(left: 16, bottom: 0, child: Text(formatDur(position))),
      Positioned(right: 16, bottom: 0, child: Text(formatDur(duration)))
    ]);
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
