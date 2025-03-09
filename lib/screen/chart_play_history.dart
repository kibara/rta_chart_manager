import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/styles/color_theme.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:rta_chart_manager/database/models/chart_play_time_model.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';
import 'package:rta_chart_manager/route.dart';

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

  late final List<ChapterSummaryModel> _chapterSummaryList;
  late final ChartPlayTimeModel _currentPlayHistory;

  @override
  void initState() {
    _chartTitleBox = KvsUtils.getBox<ChartTitleModel>(Collections.chartTitles);
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);
    _chartPlayResultBox =
        KvsUtils.getBox<ChartPlayTimeModel>(Collections.chartPlayTimes);

    // FIXME: 共通化したい
    _chapterSummaryList = _chapterSummaryBox.values
        .where((s) => s.chartId == widget.chartTitleId)
        .toList();
    _chapterSummaryList.sort((a, b) => a.orderIndex > b.orderIndex ? 1 : -1);

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
        backgroundColor: ColorTheme.primaryColor(context),
        title: const Text('Result'),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              router.goNamed('chart_title');
            },
            icon: BackButtonIcon()),
      ),

      // body メインコンテンツの画面
      body: ListView.builder(
        itemCount: _chapterSummaryList.length,
        itemBuilder: (context, index) {
          ChapterSummaryModel summaryModel = _chapterSummaryList[index];
          String summaryId = summaryModel.id;
          return ListTile(
            leading: Text("${index + 1}."),
            title: Text(_currentPlayHistory.lapTimes[summaryId].toString()),
            subtitle: Text(summaryModel.title),
          );
        },
      ),
    );
  }
}
