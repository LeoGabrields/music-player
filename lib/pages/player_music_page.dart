import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:player_music/constants/app_color.dart';
import 'package:player_music/models/position_data_stream.dart';
import 'package:player_music/widgets/neumorphic_button_widget.dart';
import 'package:player_music/pages/components/icon_play_or_pause.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PlayerMusic extends StatefulWidget {
  final AudioController audioRepository;
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
    var audioController = Provider.of<AudioController>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: size.height * 0.055),
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
            SizedBox(height: size.height * 0.025),
            Container(
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
            SizedBox(height: size.height * 0.03),
            StreamBuilder<int?>(
              stream: audioController.audioPlayer.currentIndexStream,
              builder: (context, snapshot) {
                var index =
                    snapshot.data ?? widget.audioRepository.currentIndex ?? 0;
                return Column(
                  children: [
                    Text(
                      audioController.listSong[index].displayNameWOExt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 21,
                          color: AppColor.primaryTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      audioController.listSong[index].artist == '<unknown>'
                          ? 'Artista Desconhecido'
                          : audioController.listSong[index].artist ?? '',
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                        NeumorphicTheme(
                          theme: const NeumorphicThemeData(
                              baseColor: Colors.black),
                          child: NeumorphicSlider(
                            thumb: Neumorphic(
                              style: const NeumorphicStyle(
                                depth: 10,
                                intensity: 0,
                                shape: NeumorphicShape.convex,
                                color: Colors.black45,
                              ),
                              child: CircleAvatar(
                                maxRadius: 10,
                                backgroundColor: Colors.grey.shade900,
                                child: const CircleAvatar(
                                  maxRadius: 4,
                                  backgroundColor: Color(0xFFA02017),
                                ),
                              ),
                            ),
                            sliderHeight: 5,
                            height: 5,
                            max: positionData.duration.inSeconds.toDouble(),
                            min: 0,
                            value: positionData.position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await widget.audioRepository.audioPlayer
                                  .seek(position);
                            },
                            style: const SliderStyle(
                              border: NeumorphicBorder(
                                width: 0.6,
                                color: Colors.black38,
                              ),
                              depth: -20,
                              accent: AppColor.backgroundColor,
                              variant: Color(0xFFA02017),
                            ),
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
                    onPressed: () {
                      setState(() {});
                    },
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
                  IconPlayOrPause(
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
    );
  }
}
