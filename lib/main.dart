import 'package:flutter/material.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/route.dart';

/// エントリーポイント
Future<void> main() async {
  await prepareKvs();
  runApp(const RTAChartManager());
}

/// KVSの準備
Future<void> prepareKvs() async {
  await KvsUtils.init();
  await KvsUtils.openBox(Collections.chartTitles);
  await KvsUtils.openBox(Collections.chartDetails);
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
