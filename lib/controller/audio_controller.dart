import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioController extends ChangeNotifier {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> listSong = [];
  int? currentIndex;

  Future<List<SongModel>> querySongs() async {
    try {
      listSong = await audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
          sortType: SongSortType.DISPLAY_NAME);
    } catch (e) {
      debugPrint(e.toString());
    }
    return listSong;
  }

  void currentIndexAtt(int index) {
    currentIndex = index;
    notifyListeners();
  }

  ConcatenatingAudioSource createPlaylist() {
    List<AudioSource> sources = [];
    for (var song in listSong) {
      if (song.uri != null) {
        sources.add(AudioSource.uri(Uri.parse(song.uri!)));
      }
    }
    return ConcatenatingAudioSource(children: sources);
  }

  Future<void> setAudio(ConcatenatingAudioSource audios) async {
    await audioPlayer.setAudioSource(audios, initialIndex: currentIndex);
  }

  void initPlayList(int index) async {
    if (audioPlayer.currentIndex != index) {
      currentIndexAtt(index);
      await setAudio(createPlaylist());
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
