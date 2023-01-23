import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/constants/app_color.dart';
import 'package:player_music/widgets/neumorphic_button_widget.dart';
import 'package:player_music/pages/player_music_page.dart';
import 'package:provider/provider.dart';
import '../controller/audio_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var audioRepository = Provider.of<AudioController>(context);
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
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: audioRepository.audioPlayer.currentIndex == index
                          ? Colors.black54
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PlayerMusic(audioRepository: audioRepository),
                      ));

                      audioRepository.initPlayList(index);
                    },
                    leading: NeumorphicButtonCustom(
                      heigth: 60,
                      width: 60,
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white54,
                      ),
                      function: () {},
                    ),
                    title: Text(
                      audio.displayNameWOExt,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColor.primaryTextColor),
                    ),
                    subtitle: Text(
                      audio.artist == '<unknown>'
                          ? 'Artista Desconhecido'
                          : audio.artist ?? '',
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
