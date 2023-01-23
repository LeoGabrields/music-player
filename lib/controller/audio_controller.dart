import 'dart:developer';

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
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return listSong;
  }

  currentIndexAtt(int index) {
    audioPlayer.currentIndexStream.listen((event) {
      currentIndex = event;
      notifyListeners();
    });
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
    notifyListeners();
  }

  initPlayList(int index) async {
    log('o index é = $index e o currentIndex é $currentIndex');
    if (currentIndex != index) {
      currentIndexAtt(index);
      await setAudio(createPlaylist());
      await audioPlayer.play();
    }
    notifyListeners();
  }

  nextAudio() async {
    await audioPlayer.seekToNext();
    notifyListeners();
  }

  previousAudio() {
    audioPlayer.seekToPrevious();
    notifyListeners();
  }
}
