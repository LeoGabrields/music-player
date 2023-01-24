import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/constants/app_color.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/pages/player_music_page.dart';
import 'package:provider/provider.dart';

class AlbumMusicsPage extends StatelessWidget {
  final List<SongModel> list;
  final TypePlaylist type;
  const AlbumMusicsPage({super.key, required this.list, required this.type});

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
        itemCount: list.length,
        itemBuilder: (context, index) {
          var audio = list[index];
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
                  builder: (context) => PlayerMusic(playList: list),
                ));
                audioController.initPlayList(index, list, type);
              },
              title: Text(
                list[index].displayNameWOExt,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.primaryTextColor,
                ),
              ),
              subtitle: Text(
                list[index].artist == '<unknown>'
                    ? 'Artista Desconhecido'
                    : audio.artist ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.secondaryTextColor,
                ),
              ),
              trailing: Text(
                list[index].fileExtension,
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
