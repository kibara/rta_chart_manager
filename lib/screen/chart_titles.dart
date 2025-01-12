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
  late final Box _chartTitleBox;

  @override
  void initState() {
    _chartTitleBox = KvsUtils.getBox(Collections.chartTitles);
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
        title: Text(widget.title),
      ),

      // body メインコンテンツの画面
      body: ValueListenableBuilder(
          valueListenable: _chartTitleBox.listenable(),
          builder: (context, box, widget) {
            return Center(
              child: ListView.builder(
                  itemCount: _chartTitleBox.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ChartTitleCard(
                      index: index,
                      chartTitleBox: _chartTitleBox,
                    );
                  }),
            );
          }),

      // フローティングボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? newChartTitle =
              await DialogUtils.showEditingDialog(context, '無題');
          if (newChartTitle != null) {
            _chartTitleBox.add(newChartTitle);
          }
        },
        tooltip: '新規作成',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// チャートタイトルが書かれたカード
class _ChartTitleCard extends StatelessWidget {
  final int index;
  final Box chartTitleBox;

  const _ChartTitleCard({
    required this.index,
    required this.chartTitleBox,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(chartTitleBox.getAt(index).toString()),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            final String? editedChartTitle =
                await DialogUtils.showEditingDialog(
                    context, chartTitleBox.getAt(index).toString());
            if (editedChartTitle != null) {
              chartTitleBox.putAt(index, editedChartTitle);
            }
          },
        ),
        onTap: () => {print("on card tap $index")},
      ),
    );
  }
}
