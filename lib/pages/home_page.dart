import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/constants/app_color.dart';
import 'package:player_music/widgets/neumorphic_button_widget.dart';
import 'package:player_music/pages/player_music_page.dart';
import '../repository/audio_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioRepository audioRepository = AudioRepository(audioQuery: OnAudioQuery());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<List<SongModel>>(
          future: audioRepository.querySongs(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Nada Encontrado!'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var audio = snapshot.data![index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: audioRepository.currentIndex == index
                          ? Colors.black54
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: NeumorphicButtonCustom(
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white54,
                      ),
                      function: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PlayerMusic(audioRepository: audioRepository),
                        ));
                        setState(() {
                          audioRepository.initPlayList(index);
                        });
                      },
                    ),
                    title: Text(
                      audio.displayNameWOExt,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColor.primaryTextColor),
                    ),
                    subtitle: Text(
                      audio.artist ?? '',
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.secondaryTextColor),
                    ),
                    trailing: Text(audio.duration.toString(),
                        style: const TextStyle(
                            fontSize: 12, color: AppColor.secondaryTextColor)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
