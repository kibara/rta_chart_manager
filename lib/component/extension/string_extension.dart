extension StringExtension on String {
  /// 文字列からDurationへ
  /// HH:mm:ss.SS 形式であることが前提
  Duration conv2Duration() {
    List<String> HHmm = split(':');
    List<String> ssSS = HHmm[2].split('.');

    int hours = int.parse(HHmm[0]);
    int minutes = int.parse(HHmm[1]);
    int seconds = int.parse(ssSS[0]);
    int milliseconds = int.parse(ssSS[1]);

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }
}
