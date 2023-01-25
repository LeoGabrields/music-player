import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RequestPermission {
  static Future call() async {
    var audioQuery = OnAudioQuery();
    if (!kIsWeb) {
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
    }
  }
}
