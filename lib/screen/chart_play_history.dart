import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/component/stop_watch/chart_timer.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:rta_chart_manager/database/models/chart_play_time_model.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';

class ChartPlayResult extends StatefulWidget {
  const ChartPlayResult({
    super.key,
    required this.chartTitleId,
    required this.chartPlayId,
  });

  final String chartTitleId;
  final String chartPlayId;

  // ステートを定義する
  @override
  State<ChartPlayResult> createState() => _ChartTitlesState();
}

class _ChartTitlesState extends State<ChartPlayResult> {
  late final Box<ChartTitleModel> _chartTitleBox;
  late final Box<ChapterSummaryModel> _chapterSummaryBox;
  late final Box<ChartPlayTimeModel> _chartPlayResultBox;

  late final ChartPlayTimeModel _currentPlayHistory;

  @override
  void initState() {
    _chartTitleBox = KvsUtils.getBox<ChartTitleModel>(Collections.chartTitles);
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);
    _chartPlayResultBox =
        KvsUtils.getBox<ChartPlayTimeModel>(Collections.chartPlayTimes);

    _currentPlayHistory = _chartPlayResultBox.get(widget.chartPlayId)!;

    super.initState();
  }

  // アプリの画面構成と挙動を構成する
  @override
  Widget build(BuildContext context) {
    // Scaffold = アプリのメイン画面全体
    return Scaffold(
      // appBar 上部のバー
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result'),
      ),

      // body メインコンテンツの画面
      body: ListView.builder(
        itemCount: _currentPlayHistory.lapTimes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text("${index + 1}."),
            // FIXME: 本当はsummaryのsortOrderに沿ってsummaryIdで取得するのが正しい
            title:
                Text("${_currentPlayHistory.lapTimes.values.elementAt(index)}"),
          );
        },
      ),
    );
  }
}
