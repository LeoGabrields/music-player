class Convert {
  static String durationToString(Duration duration) {
    int remainderMinutes = duration.inMinutes.remainder(60);
    int remainderSeconds = duration.inSeconds.remainder(60);

    String sRemainderMinutes = remainderMinutes.toString();
    String sRemainderSeconds = remainderSeconds.toString();

    return '$sRemainderMinutes:${sRemainderSeconds.padLeft(2, '0')}';
  }
}
