import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late final Box _chartTitleBox;
  late final Box _chartDetailBox;

  @override
  void initState() {
    _chartTitleBox = KvsUtils.getBox(Collections.chartTitles);
    _chartDetailBox = KvsUtils.getBox(Collections.chartDetails);
    super.initState();
  }

  /// チャート新規作成
  void _addNewChartTitle() async {
    final String? newChartTitle =
        await DialogUtils.showEditingDialog(context, '無題');
    if (newChartTitle != null) {
      _chartTitleBox.add(newChartTitle);
      _chartDetailBox.put(newChartTitle, {});
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
    String chartTitle = _chartTitleBox.getAt(index);
    _chartTitleBox.deleteAt(index);
    _chartDetailBox.delete(chartTitle);
  }

  /// チャート詳細に遷移
  void _navChartDetail(int index, BuildContext context) {
    //
    print("on tap card $index");
    String chartTitle = _chartTitleBox.getAt(index);
    context.push('/chart_detail', extra: chartTitle);
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
                      cardOnTap: () => _navChartDetail(index, context),
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
  final VoidCallback cardOnTap;

  const _ChartTitleCard({
    required this.index,
    required this.title,
    required this.editButtonOnPressed,
    required this.deleteButtonOnPressed,
    required this.cardOnTap,
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
        onTap: cardOnTap,
      ),
    );
  }
}
