extension DurationExtension on Duration {
  String fmtHHmmssSS() {
    return _formatDuration(this);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) {
      if (n.isNaN) return "00";
      return n.toString().padLeft(2, "0").substring(0, 2);
    }

    // 符号の取得
    String negativeSign = d.isNegative ? '-' : '';

    // 各値の絶対値を取得
    int hour = d.inHours.abs();
    int min = d.inMinutes.remainder(60).abs();
    int sec = d.inSeconds.remainder(60).abs();
    int mills = d.inMilliseconds.remainder(1000).abs();

    // 各値を2桁の文字列に変換
    String strHour = twoDigits(hour);
    String strMin = twoDigits(min);
    String strSec = twoDigits(sec);
    String strMills = twoDigits(mills);

    // フォーマット
    return "$negativeSign$strHour:$strMin:$strSec.$strMills";
  }
}
