import 'package:flutter/material.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';
import 'package:rta_chart_manager/database/models/chart_detail_model.dart';
import 'package:rta_chart_manager/database/models/chart_summary_model.dart';
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
  await KvsUtils.init();
  KvsUtils.registerAdapter<ChartTitleModel>(ChartTitleModelAdapter());
  await KvsUtils.openBox<ChartTitleModel>(Collections.chartTitles);
  KvsUtils.registerAdapter<ChartSummaryModel>(ChartSummaryModelAdapter());
  await KvsUtils.openBox<ChartSummaryModel>(Collections.chartSummary);
  KvsUtils.registerAdapter<ChartDetailModel>(ChartDetailModelAdapter());
  KvsUtils.registerAdapter<ActionItemModel>(ActionItemModelAdapter());
  KvsUtils.registerAdapter<Duration>(DurationAdapter());
  await KvsUtils.openBox<ChartDetailModel>(Collections.chartDetails);
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
