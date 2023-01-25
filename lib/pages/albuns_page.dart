import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/utils/app_color.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/pages/album_musics_page.dart';
import 'package:provider/provider.dart';

class AlbunsPage extends StatelessWidget {
  const AlbunsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var audioRepository = Provider.of<AudioController>(context);
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: FutureBuilder<List<AlbumModel>>(
        future: audioRepository.queryAlbuns(),
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
                    subtitle: const Text(
                      'Álbum',
                      style: TextStyle(color: AppColor.secondaryTextColor),
                    ),
                    trailing: Text('${albumModel.numOfSongs}'),
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
