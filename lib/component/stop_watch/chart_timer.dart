import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:async/async.dart';

class ChartTimer extends StatefulWidget {
  const ChartTimer({super.key});

  static final _stopWatchTimer = StopWatchTimer();
  static final StreamQueue<List<StopWatchRecord>> _records =
      StreamQueue(ChartTimer._stopWatchTimer.records);

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
    _stopWatchTimer.onResetTimer();
  }

  /// ラップタイムを追加し、最終ラップタイムを返す
  static Future<List<StopWatchRecord>> addLap() async {
    _stopWatchTimer.onAddLap();
    return _records.next;
  }

  @override
  State<ChartTimer> createState() => _ChartTimerState();
}

class _ChartTimerState extends State<ChartTimer> {
  @override
  void initState() {
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
