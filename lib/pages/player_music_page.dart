import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:player_music/constants/app_color.dart';
import 'package:player_music/models/position_data_stream.dart';
import 'package:player_music/widgets/neumorphic_button_widget.dart';
import 'package:player_music/pages/components/icon_play_or_pause.dart';
import 'package:player_music/repository/audio_repository.dart';
import 'package:player_music/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class PlayerMusic extends StatefulWidget {
  final AudioRepository audioRepository;
  const PlayerMusic({super.key, required this.audioRepository});

  @override
  State<PlayerMusic> createState() => _PlayerMusicState();
}

class _PlayerMusicState extends State<PlayerMusic> {
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest2<Duration, Duration?, PositionData>(
          widget.audioRepository.audioPlayer.positionStream,
          widget.audioRepository.audioPlayer.durationStream,
          (position, duration) => PositionData(
              position: position, duration: duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    var audio = widget.audioRepository.listSong;
    var audioPlayer = widget.audioRepository.audioPlayer;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Neumorphic(
        style: const NeumorphicStyle(
            color: AppColor.backgroundColor, shape: NeumorphicShape.convex),
        child: Container(
          margin: EdgeInsets.only(top: size.height * 0.04),
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NeumorphicButtonCustom(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        function: () => Navigator.of(context).pop()),
                    const Text(
                      'PLAYING NOW',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    NeumorphicButtonCustom(
                      icon: const Icon(
                        Icons.list,
                        color: Colors.grey,
                      ),
                      function: () {},
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.025),
              Container(
                height: size.height * 0.37,
                width: size.width * 0.78,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(width: 8, color: Colors.black45),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.asset('assets/image.jpg', fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              StreamBuilder<int?>(
                stream: audioPlayer.currentIndexStream,
                builder: (context, snapshot) {
                  var index =
                      snapshot.data ?? widget.audioRepository.currentIndex ?? 0;
                  return Column(
                    children: [
                      Text(
                        audio[index].displayNameWOExt,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 21,
                            color: AppColor.primaryTextColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        audio[index].artist!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.secondaryTextColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: size.height * 0.08),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Utils.converterDurationToString(
                                      positionData!.position),
                                  style: const TextStyle(
                                    color: AppColor.secondaryTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  Utils.converterDurationToString(
                                      positionData.duration),
                                  style: const TextStyle(
                                    color: AppColor.secondaryTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: positionData.position.inSeconds.toDouble(),
                              min: 0,
                              max: positionData.duration.inSeconds.toDouble(),
                              activeColor: const Color(0xFFA02017),
                              inactiveColor: Colors.black,
                              onChanged: (value) async {
                                final position =
                                    Duration(seconds: value.toInt());
                                await widget.audioRepository.audioPlayer
                                    .seek(position);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const LinearProgressIndicator(
                        color: Color(0x379E9E9E),
                        backgroundColor: Color(0x379E9E9E),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: size.height * 0.04),
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.repeat_outlined),
                      color: AppColor.secondaryTextColor,
                    ),
                    NeumorphicButtonCustom(
                      size: 15,
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: Colors.white,
                      ),
                      function: audioPlayer.seekToPrevious,
                    ),
                    IconPlayOrPause(
                      pause: audioPlayer.pause,
                      seek: audioPlayer.seek,
                      play: audioPlayer.play,
                      stream: audioPlayer.playerStateStream,
                    ),
                    NeumorphicButtonCustom(
                        size: 15,
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                        ),
                        function: audioPlayer.seekToNext),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shuffle_outlined,
                        color: AppColor.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
