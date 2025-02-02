extension DatetimeExtension on DateTime {
  /// ここでは符号は考えず、絶対値で時刻形式にする
  Duration conv2Duration() {
    return Duration(
      days: 0,
      hours: hour,
      minutes: minute,
      seconds: second,
      milliseconds: millisecond,
      microseconds: microsecond,
    );
  }
}
