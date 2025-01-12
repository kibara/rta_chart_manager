import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';

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
  late final Box _chartTitleBox;

  @override
  void initState() {
    _chartTitleBox = KvsUtils.getBox(Collections.chartTitles);
    _loadChartTitle();
    super.initState();
  }

  /// チャートを追加する
  void _addNewChart(String title) {
    _chartTitles.add(title);
    _saveChartTitle();
  }

  /// チャートのタイトルを変更する
  void _changeChartTile(int index, String title) {
    _chartTitles[index] = title;
    _saveChartTitle();
  }

  /// チャートのタイトルを保存する
  void _saveChartTitle() async {
    _chartTitleBox.put('chart_titles', _chartTitles);
  }

  /// 保存されているチャートのタイトルを取得する
  void _loadChartTitle() {
    _chartTitles.clear();
    _chartTitles.addAll(
        List.from(_chartTitleBox.get('chart_titles', defaultValue: [])));
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
      body: ValueListenableBuilder(
          valueListenable: _chartTitleBox.listenable(),
          builder: (context, box, widget) {
            return Center(
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
                        onTap: () => {print("on card tap $index")},
                      ),
                    );
                  }),
            );
          }),

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
