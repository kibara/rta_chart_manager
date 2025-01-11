import 'package:flutter/material.dart';
import 'package:rta_chart_flutter/route.dart';

void main() {
  runApp(const RTAChartManager());
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
