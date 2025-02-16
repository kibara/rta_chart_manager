extension DurationExtension on Duration {
  String fmtHHmmssSS() {
    String twoDigits(int n) {
      if (n.isNaN) return "00";
      return n.toString().padLeft(2, "0").substring(0, 2);
    }

    // 符号の取得
    String negativeSign = isNegative ? '-' : '';

    // 各値の絶対値を取得
    int hour = inHours.abs();
    int min = inMinutes.remainder(60).abs();
    int sec = inSeconds.remainder(60).abs();
    int mills = inMilliseconds.remainder(1000).abs();

    // 各値を2桁の文字列に変換
    String strHour = twoDigits(hour);
    String strMin = twoDigits(min);
    String strSec = twoDigits(sec);
    String strMills = twoDigits(mills);

    // フォーマット
    return "$negativeSign$strHour:$strMin:$strSec.$strMills";
  }

  /// 文字列からDurationへ
  /// HH:mm:ss.SS 形式であることが前提
  static Duration fromString(String s) {
    List<String> HHmm = s.split(':');
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

  /// ここでは符号は考えず、絶対値で時刻形式にする
  DateTime conv2Datetime() {
    return DateTime.utc(
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      inMicroseconds.abs(),
    );
  }
}
