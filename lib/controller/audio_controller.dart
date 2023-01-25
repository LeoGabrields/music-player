import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_music/models/position_data_stream.dart';
import 'package:rxdart/rxdart.dart';

enum TypePlaylist { allMusic, artistMusic, albumMusic }

class AudioController extends ChangeNotifier {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> _listSong = [];
  TypePlaylist? typePlaylist;
  int? currentIndex;

  Stream<PositionData> get positionDataStream {
    return Rx.combineLatest2<Duration, Duration?, PositionData>(
      audioPlayer.positionStream,
      audioPlayer.durationStream,
      (position, duration) =>
          PositionData(position: position, duration: duration ?? Duration.zero),
    );
  }

  List<SongModel> filterMusic(String name, String type) {
    if (type == 'Album') {
      return _listSong
          .where(
              (element) => element.album!.toLowerCase() == name.toLowerCase())
          .toList();
    } else {
      return _listSong
          .where(
              (element) => element.artist!.toLowerCase() == name.toLowerCase())
          .toList();
    }
  }

  Future<List<SongModel>> getSongs() async {
    try {
      _listSong = await audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
        sortType: SongSortType.DISPLAY_NAME,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return _listSong;
  }

  Future<List<AlbumModel>> getAlbuns() async {
    List<AlbumModel> listAlbuns = [];
    try {
      listAlbuns = await audioQuery.queryAlbums(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return listAlbuns;
  }

  Future<List<ArtistModel>> getArtist() async {
    List<ArtistModel> listArtist = [];
    try {
      listArtist = await audioQuery.queryArtists(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return listArtist;
  }

  void currentIndexAtt(int index) {
    currentIndex = index;
    notifyListeners();
  }

  ConcatenatingAudioSource createPlaylist(List playlist) {
    List<AudioSource> sources = [];
    sources.clear();
    for (var music in playlist) {
      if (music.uri != null) {
        sources.add(AudioSource.uri(Uri.parse(music.uri!)));
      }
    }
    return ConcatenatingAudioSource(children: sources);
  }

  Future<void> setAudio(ConcatenatingAudioSource audios) async {
    await audioPlayer.setAudioSource(audios, initialIndex: currentIndex);
  }

  void initPlayList(int index, List playlist, TypePlaylist type) async {
    if (audioPlayer.currentIndex != index || type != typePlaylist) {
      typePlaylist = type;
      currentIndexAtt(index);
      await setAudio(createPlaylist(playlist));
      await audioPlayer.play();
    }
    notifyListeners();
  }

  void nextAudio() async {
    await audioPlayer.seekToNext();
    notifyListeners();
  }

  void previousAudio() {
    audioPlayer.seekToPrevious();
    notifyListeners();
  }
}
