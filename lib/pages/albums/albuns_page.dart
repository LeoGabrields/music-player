import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/pages/albums/album_musics_page.dart';
import 'package:player_music/utils/app_color.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:provider/provider.dart';

class AlbunsPage extends StatelessWidget {
  const AlbunsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var audioRepository = Provider.of<AudioController>(context);
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: FutureBuilder<List<AlbumModel>>(
        future: audioRepository.getAlbuns(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var albumModel = snapshot.data![index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AlbumMusicsPage(
                          playList: audioRepository.filterMusic(
                            albumModel.album,
                            'Album',
                          ),
                          type: TypePlaylist.albumMusic,
                        ),
                      ),
                    ),
                    leading: QueryArtworkWidget(
                      id: albumModel.id,
                      type: ArtworkType.ALBUM,
                    ),
                    title: Text(
                      albumModel.album,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColor.primaryTextColor),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        text: '${albumModel.numOfSongs} ',
                        style:
                            const TextStyle(color: AppColor.secondaryTextColor),
                        children: [
                          TextSpan(
                            text: albumModel.numOfSongs <= 1
                                ? 'Música'
                                : 'Músicas',
                            style: const TextStyle(
                                color: AppColor.secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
