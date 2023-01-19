import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioRepository {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> querySongs() async {
    var listSong = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    debugPrint(listSong.toString());
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
