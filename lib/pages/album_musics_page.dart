import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/utils/app_color.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/pages/player_music_page.dart';
import 'package:provider/provider.dart';

class AlbumMusicsPage extends StatelessWidget {
  final List<SongModel> playList;
  final TypePlaylist type;
  const AlbumMusicsPage({super.key, required this.playList, required this.type});

  @override
  Widget build(BuildContext context) {
    var audioController = Provider.of<AudioController>(context);
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Álbum',
          style: TextStyle(color: AppColor.primaryTextColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: ListView.builder(
        itemCount: playList.length,
        itemBuilder: (context, index) {
          var audio = playList[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: audioController.audioPlayer.currentIndex == index &&
                        audioController.typePlaylist == type
                    ? Colors.black54
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlayerMusic(playList: playList),
                ));
                audioController.initPlayList(index, playList, type);
              },
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
      ),
    );
  }
}
