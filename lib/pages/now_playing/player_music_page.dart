import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/utils/app_color.dart';
import 'package:player_music/models/position_data_stream.dart';
import 'package:player_music/widgets/neumorphic_button_widget.dart';
import 'package:player_music/widgets/icon_button_play_or_pause.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/utils/convert_duration_to_string.dart';
import 'package:provider/provider.dart';

class PlayerMusic extends StatelessWidget {
  final List<SongModel> playList;
  const PlayerMusic({super.key, required this.playList});

  @override
  Widget build(BuildContext context) {
    var audioController = Provider.of<AudioController>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NeumorphicButtonCustom(
                          heigth: 55,
                          width: 55,
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
                        heigth: 55,
                        width: 55,
                        icon: const Icon(
                          Icons.list,
                          color: Colors.grey,
                        ),
                        function: () {},
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: size.width * 0.8,
                    height: size.height * 0.35,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 54, 54, 61),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(38, 255, 255, 255),
                          blurRadius: 25,
                          offset: Offset(-10, -10),
                        ),
                        BoxShadow(
                          color: Color.fromARGB(164, 0, 0, 0),
                          blurRadius: 23,
                          offset: Offset(10, 10),
                        )
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 80, 80, 83),
                            Color(0xff202026),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.asset(
                          'assets/image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                StreamBuilder<int?>(
                  stream: audioController.audioPlayer.currentIndexStream,
                  builder: (context, snapshot) {
                    var index =
                        snapshot.data ?? audioController.currentIndex ?? 0;
                    return Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Text(
                              playList[index].displayNameWOExt,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 21,
                                  color: AppColor.primaryTextColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              playList[index].artist == '<unknown>'
                                  ? 'Artista Desconhecido'
                                  : playList[index].artist ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColor.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  flex: 2,
                  child: StreamBuilder<PositionData>(
                    stream: audioController.positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Convert.durationToString(
                                        positionData!.position),
                                    style: const TextStyle(
                                      color: AppColor.secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    Convert.durationToString(
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
                                thumbShape: const RoundSliderThumbShape(
                                  disabledThumbRadius: 2,
                                  elevation: 4,
                                  pressedElevation: 0,
                                  enabledThumbRadius: 6,
                                ),
                              ),
                              child: Slider(
                                value:
                                    positionData.position.inSeconds.toDouble(),
                                min: 0,
                                max: positionData.duration.inSeconds.toDouble(),
                                activeColor: const Color(0xFFA02017),
                                inactiveColor: Colors.black,
                                onChanged: (value) async {
                                  final position =
                                      Duration(seconds: value.toInt());
                                  await audioController.audioPlayer
                                      .seek(position);
                                },
                              ),
                            ),
                          ],
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
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(Icons.repeat_outlined),
                          color: AppColor.secondaryTextColor,
                        ),
                        NeumorphicButtonCustom(
                          heigth: 60,
                          width: 60,
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                          ),
                          function: () {
                            audioController.previousAudio();
                          },
                        ),
                        IconButtonPlayOrPause(
                          pause: audioController.audioPlayer.pause,
                          seek: audioController.audioPlayer.seek,
                          play: audioController.audioPlayer.play,
                          stream: audioController.audioPlayer.playerStateStream,
                        ),
                        NeumorphicButtonCustom(
                            heigth: 60,
                            width: 60,
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                            ),
                            function: () {
                              audioController.nextAudio();
                            }),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.shuffle_outlined,
                            color: AppColor.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
