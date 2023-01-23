import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:player_music/widgets/neumorphic_button_widget.dart';

class IconPlayOrPause extends StatelessWidget {
  final void Function() play;
  final void Function() pause;
  final Function seek;
  final Stream<PlayerState> stream;
  const IconPlayOrPause({
    Key? key,
    required this.play,
    required this.pause,
    required this.seek,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: stream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 64.0,
            height: 64.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return NeumorphicButtonCustom(
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            size: 22,
            function: play,
          );
        } else if (processingState != ProcessingState.completed) {
          return NeumorphicButtonCustom(
            color: const Color(0xFFA02017),
            icon: const Icon(
              Icons.pause,
              color: Colors.white,
            ),
            size: 22,
            function: pause,
          );
        } else {
          return NeumorphicButtonCustom(
            icon: const Icon(
              Icons.replay,
              color: Colors.white,
            ),
            size: 22,
            function: () => seek(Duration.zero),
          );
        }
      },
    );
  }
}
