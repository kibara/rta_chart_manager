import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ChartTimer extends StatefulWidget {
  const ChartTimer({super.key});

  static final stopWatchTimer = StopWatchTimer();

  @override
  State<ChartTimer> createState() => _ChartTimerState();
}

class _ChartTimerState extends State<ChartTimer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChartTimer.stopWatchTimer.rawTime,
      initialData: ChartTimer.stopWatchTimer.rawTime.value,
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
