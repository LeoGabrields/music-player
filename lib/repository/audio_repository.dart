import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioRepository {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> querySongs() async {
    List<SongModel> listSong = [];
    try {
      listSong = await _audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return listSong;
  }

  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
    }
  }
}
