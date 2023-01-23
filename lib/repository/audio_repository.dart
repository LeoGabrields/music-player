import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioRepository extends ChangeNotifier {
  final OnAudioQuery audioQuery;
  AudioRepository({required this.audioQuery});

  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> listSong = [];
  int? currentIndex;

  Future<List<SongModel>> querySongs() async {
    try {
      listSong = await audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return listSong;
  }

  

  currentIndexAtt(int index) {
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

  setAudio(ConcatenatingAudioSource audios) async {
    await audioPlayer.setAudioSource(audios, initialIndex: currentIndex);
  }

  initPlayList(int index) async {
    if (currentIndex != index) {
      currentIndexAtt(index);
      await setAudio(createPlaylist());
      await audioPlayer.play();
    }
  }

  nextAudio() {
    audioPlayer.seekToNext();
  }

  previousAudio() {
    audioPlayer.seekToPrevious();
  }


}
