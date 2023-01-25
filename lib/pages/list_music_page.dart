import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/utils/app_color.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/pages/player_music_page.dart';
import 'package:provider/provider.dart';

class ListMusicPage extends StatelessWidget {
  const ListMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    var audioRepository = Provider.of<AudioController>(context);
    return SafeArea(
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: audioRepository.audioPlayer.currentIndex == index &&
                            audioRepository.typePlaylist ==
                                TypePlaylist.allMusic
                        ? Colors.black54
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PlayerMusic(playList: snapshot.data!),
                    ));

                    audioRepository.initPlayList(
                        index, snapshot.data!, TypePlaylist.allMusic);
                  },
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFA02017),
                    child: Icon(Icons.music_note),
                  ),
                  title: Text(
                    audio.displayNameWOExt,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.primaryTextColor,
                    ),
                  ),
                  subtitle: Text(
                    audio.artist == '<unknown>'
                        ? 'Artista Desconhecido'
                        : audio.artist ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                  trailing: Text(
                    audio.fileExtension,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.secondaryTextColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
