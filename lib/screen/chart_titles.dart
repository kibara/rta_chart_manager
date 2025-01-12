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

  /// チャート新規作成
  void _addNewChartTitle() async {
    final String? newChartTitle =
        await DialogUtils.showEditingDialog(context, '無題');
    if (newChartTitle != null) {
      _chartTitleBox.add(newChartTitle);
    }
  }

  /// チャートタイトルの編集
  void _editChartTitle(int index) async {
    final String? editedChartTitle = await DialogUtils.showEditingDialog(
        context, _chartTitleBox.getAt(index).toString());
    if (editedChartTitle != null) {
      _chartTitleBox.putAt(index, editedChartTitle);
    }
  }

  /// チャートの削除
  void _deleteChartTitle(int index) {
    _chartTitleBox.deleteAt(index);
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
                      title: _chartTitleBox.getAt(index).toString(),
                      editButtonOnPressed: () => _editChartTitle(index),
                      deleteButtonOnPressed: () => _deleteChartTitle(index),
                    );
                  }),
            );
          }),

      // フローティングボタン
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewChartTitle,
        tooltip: '新規作成',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// TODO: ここまできたら抽象化していい気もする
/// チャートタイトルが書かれたカード
class _ChartTitleCard extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback editButtonOnPressed;
  final VoidCallback deleteButtonOnPressed;

  const _ChartTitleCard({
    required this.index,
    required this.title,
    required this.editButtonOnPressed,
    required this.deleteButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Wrap(children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editButtonOnPressed,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteButtonOnPressed,
          ),
        ]),
        onTap: () => {print("on card tap $index")},
      ),
    );
  }
}
