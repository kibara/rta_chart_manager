import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';

class ChartTitles extends StatefulWidget {
  const ChartTitles({super.key, required this.title});

  final String title;

  // ステートを定義する
  @override
  State<ChartTitles> createState() => _ChartTitlesState();
}

class _ChartTitlesState extends State<ChartTitles> {
  late final Box<ChartTitleModel> _chartTitleBox;
  late final Box _chartDetailBox;

  late final List<ChartTitleModel> _sortedChartTitles;

  @override
  void initState() {
    _chartTitleBox = KvsUtils.getBox<ChartTitleModel>(Collections.chartTitles);
    _chartDetailBox = KvsUtils.getBox(Collections.chartDetails);

    _sortedChartTitles = List.from(_chartTitleBox.values);
    sortChartTitles();

    super.initState();
  }

  void sortChartTitles() {
    _sortedChartTitles.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  /// チャート新規作成
  void _addNewChartTitle() async {
    final String? newChartTitle =
        await DialogUtils.showEditingDialog(context, '無題のチャート');

    if (newChartTitle != null) {
      ChartTitleModel newChart = ChartTitleModel(newChartTitle);
      newChart.orderIndex = _chartTitleBox.length;
      _sortedChartTitles.add(newChart);
      _chartTitleBox.put(newChart.id, newChart);
      _chartDetailBox.put(newChart.id, {});
    }
  }

  /// チャートタイトルの編集
  void _editChartTitle(int index) async {
    ChartTitleModel chartTitleModel = _sortedChartTitles[index];
    final String? editedChartTitle =
        await DialogUtils.showEditingDialog(context, chartTitleModel.title);

    if (editedChartTitle != null) {
      chartTitleModel.title = editedChartTitle;
      _chartTitleBox.put(chartTitleModel.id, chartTitleModel);
      _sortedChartTitles[index] = chartTitleModel;
    }
  }

  /// チャートの削除
  void _deleteChartTitle(int index) {
    ChartTitleModel chartTitleModel = _sortedChartTitles[index];
    _sortedChartTitles.removeAt(index);
    _chartTitleBox.delete(chartTitleModel.id);
    _chartDetailBox.delete(chartTitleModel.id);
  }

  /// チャート詳細に遷移
  void _navChartSummary(int index, BuildContext context) {
    //
    print("on tap card $index");
    ChartTitleModel chartTitleModel = _sortedChartTitles[index];
    context.push('/chart_summary', extra: chartTitleModel.id);
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
                  itemCount: _sortedChartTitles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _ChartTitleCard(
                      index: index,
                      title: _sortedChartTitles[index].title,
                      editButtonOnPressed: () => _editChartTitle(index),
                      deleteButtonOnPressed: () => _deleteChartTitle(index),
                      cardOnTap: () => _navChartSummary(index, context),
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
