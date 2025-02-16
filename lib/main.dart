import 'package:flutter/material.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';
import 'package:rta_chart_manager/database/models/chapter_detail_model.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:rta_chart_manager/database/models/chart_play_time_model.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';
import 'package:rta_chart_manager/database/models/duration_adapter.dart';
import 'package:rta_chart_manager/route.dart';

/// エントリーポイント
Future<void> main() async {
  await prepareKvs();
  runApp(const RTAChartManager());
}

/// KVSの準備
Future<void> prepareKvs() async {
  // Hive初期化
  await KvsUtils.init();

  // チャート
  KvsUtils.registerAdapter<ChartTitleModel>(ChartTitleModelAdapter());
  await KvsUtils.openBox<ChartTitleModel>(Collections.chartTitles);

  // チャプターサマリ
  KvsUtils.registerAdapter<ChapterSummaryModel>(ChapterSummaryModelAdapter());
  await KvsUtils.openBox<ChapterSummaryModel>(Collections.chapterSummary);

  // チャプター詳細
  KvsUtils.registerAdapter<ChapterDetailModel>(ChapterDetailModelAdapter());
  KvsUtils.registerAdapter<ActionItemModel>(ActionItemModelAdapter());
  KvsUtils.registerAdapter<Duration>(DurationAdapter());
  await KvsUtils.openBox<ChapterDetailModel>(Collections.chapterDetails);

  // チャートプレイ時間
  KvsUtils.registerAdapter<ChartPlayTimeModel>(ChartPlayTimeModelAdapter());
  await KvsUtils.openBox<ChartPlayTimeModel>(Collections.chartPlayTimes);
}

class RTAChartManager extends StatelessWidget {
  const RTAChartManager({super.key});

  // アプリケーショントップ・エントリーポイント
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
