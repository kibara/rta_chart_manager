import 'package:flutter/material.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';

class ChartTitles extends StatefulWidget {
  const ChartTitles({super.key, required this.title});

  final String title;

  // ステートを定義する
  @override
  State<ChartTitles> createState() => _ChartTitlesState();
}

class _ChartTitlesState extends State<ChartTitles> {
  // ステートで保持する値
  // {
  //     "chart_title": [{ * chart_part1_json * }, { * chart_part2_json * }],
  //     ...
  // }
  final Map<String, dynamic> _charts = {};
  final List<String> _chartTitles = [];

  // イベントで発火する関数の定義
  void _addNewChart(String title) {
    setState(() {
      _chartTitles.add(title);
    });
  }

  void _changeChartTile(int index, String title) {
    setState(() {
      _chartTitles[index] = title;
    });
  }

  // アプリの画面構成と挙動を構成する
  @override
  Widget build(BuildContext context) {
    // Scaffold = アプリのメイン画面全体
    return Scaffold(
      // appBar 上部のバー
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // body メインコンテンツの画面
      body: Center(
        child: ListView.builder(
            itemCount: _chartTitles.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(_chartTitles[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final String? chartTitle =
                          await DialogUtils.showEditingDialog(
                              context, _chartTitles[index]);
                      if (chartTitle != null) {
                        _changeChartTile(index, chartTitle);
                      }
                    },
                  ),
                ),
              );
            }),
      ),

      // フローティングボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? chartTitle =
              await DialogUtils.showEditingDialog(context, '無題');
          if (chartTitle != null) {
            _addNewChart(chartTitle);
          }
        },
        tooltip: '新規作成',
        child: const Icon(Icons.add),
      ),
    );
  }
}
