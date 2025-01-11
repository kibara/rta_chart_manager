import 'package:flutter/material.dart';
import 'package:rta_chart_flutter/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // アプリケーショントップ・エントリーポイント
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
