import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ChartTimer extends StatefulWidget {
  const ChartTimer({super.key});

  static final _stopWatchTimer = StopWatchTimer();
  static final _records = [];

  /// タイマースタート
  static void start() {
    _stopWatchTimer.onStartTimer();
  }

  /// タイマーストップ
  static void stop() {
    _stopWatchTimer.onStopTimer();
  }

  /// タイマーのリセット
  static void reset() {
    _records.clear();
    _stopWatchTimer.onResetTimer();
  }

  /// ラップタイムの追加
  static String addLap() {
    _stopWatchTimer.onAddLap();
    return getLastLapTime();
  }

  /// 最終ラップタイムを取得
  static String getLastLapTime() {
    return _records.last ?? '00:00:00.00';
  }

  @override
  State<ChartTimer> createState() => _ChartTimerState();
}

class _ChartTimerState extends State<ChartTimer> {
  static bool initialized = false;

  @override
  void initState() {
    if (!initialized) {
      initialized = true;
      ChartTimer._stopWatchTimer.records.listen((records) async {
        if (records.isNotEmpty) {
          ChartTimer._records.add(records.last.displayTime!);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChartTimer._stopWatchTimer.rawTime,
      initialData: ChartTimer._stopWatchTimer.rawTime.value,
      builder: (context, snapshot) {
        final displayTime = StopWatchTimer.getDisplayTime(snapshot.data!);
        return Center(
            child: Text(
          displayTime,
          style: TextStyle(fontSize: 36),
        ));
      },
    );
  }
}
