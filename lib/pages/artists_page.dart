import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/constants/app_color.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/pages/album_musics_page.dart';
import 'package:provider/provider.dart';

class ArtistsPage extends StatelessWidget {
  const ArtistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var audioRepository = Provider.of<AudioController>(context);
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: FutureBuilder<List<ArtistModel>>(
        future: audioRepository.queryArtist(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var artistModel = snapshot.data![index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AlbumMusicsPage(
                          list: audioRepository.filterMusic(
                            artistModel.artist,
                            'Artist',
                          ),
                          type: TypePlaylist.artistMusic,
                        ),
                      ),
                    ),
                    leading: QueryArtworkWidget(
                      id: artistModel.id,
                      type: ArtworkType.ARTIST,
                    ),
                    title: Text(
                      artistModel.artist == '<unknown>'
                          ? 'Artista Desconhecido'
                          : artistModel.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColor.primaryTextColor),
                    ),
                    subtitle: const Text(
                      'Artista',
                      style: TextStyle(color: AppColor.secondaryTextColor),
                    ),
                    trailing: Text('${artistModel.numberOfTracks}'),
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
