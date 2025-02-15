import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/component/stop_watch/chart_timer.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
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
  late final Box<ChapterSummaryModel> _chapterSummaryBox;

  late final List<ChartTitleModel> _sortedChartTitles;

  @override
  void initState() {
    _chartTitleBox = KvsUtils.getBox<ChartTitleModel>(Collections.chartTitles);
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);

    _sortedChartTitles = List.from(_chartTitleBox.values);
    _sortChartTitles();

    super.initState();
  }

  /// チャートタイトルのソート
  void _sortChartTitles() {
    _sortedChartTitles.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  /// チャートタイトルの並び替えイベント
  void _reorderChartTitles(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ChartTitleModel item = _sortedChartTitles.removeAt(oldIndex);
    _sortedChartTitles.insert(newIndex, item);

    for (var i = 0; i < _sortedChartTitles.length; i++) {
      _sortedChartTitles[i].orderIndex = i;
      _sortedChartTitles[i].save();
    }
  }

  /// チャート新規作成
  void _addNewChartTitle() async {
    final String? newChartTitle =
        await DialogUtils.showEditingDialog(context, '無題のチャート');

    if (newChartTitle != null) {
      ChartTitleModel newChart = ChartTitleModel(
        newChartTitle,
        _chartTitleBox.length,
      );
      _sortedChartTitles.add(newChart);
      _chartTitleBox.put(newChart.id, newChart);
    }
  }

  /// チャートタイトルの編集
  void _editChartTitle(int index) async {
    final String? editedChartTitle = await DialogUtils.showEditingDialog(
        context, _sortedChartTitles[index].title);

    if (editedChartTitle != null) {
      _sortedChartTitles[index].title = editedChartTitle;
      _sortedChartTitles[index].save();
    }
  }

  /// チャートの削除
  void _deleteChartTitle(int index) {
    ChartTitleModel chartTitleModel = _sortedChartTitles[index];
    _sortedChartTitles.removeAt(index);
    _chartTitleBox.delete(chartTitleModel.id);
  }

  /// チャート詳細に遷移
  void _navChapterSummary(int index, BuildContext context) {
    context.goNamed(
      'chapter_summary',
      pathParameters: {
        'chartId': _sortedChartTitles[index].id,
      },
    );
  }

  /// チャートをプレイする
  void _playChart(int index) {
    ChartTitleModel chartTitleModel = _sortedChartTitles[index];
    ChapterSummaryModel? firstChapter = _chapterSummaryBox.values
        .where((s) => s.chartId == chartTitleModel.id && s.orderIndex == 0)
        .firstOrNull;

    if (firstChapter != null) {
      context.goNamed(
        'chapter_detail',
        pathParameters: {
          'chartId': chartTitleModel.id,
          'summaryId': firstChapter.id,
        },
        queryParameters: {'editMode': 'false'},
      );
      ChartTimer.reset();
      ChartTimer.start();
    }
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
              child: ReorderableListView.builder(
                itemCount: _sortedChartTitles.length,
                itemBuilder: (BuildContext context, int index) {
                  return _ChartTitleCard(
                    key: Key(_sortedChartTitles[index].id),
                    index: index,
                    title: _sortedChartTitles[index].title,
                    playButtonOnPressed: () => _playChart(index),
                    editButtonOnPressed: () => _editChartTitle(index),
                    deleteButtonOnPressed: () => _deleteChartTitle(index),
                    cardOnTap: () => _navChapterSummary(index, context),
                  );
                },
                onReorder: (oldIndex, newIndex) =>
                    _reorderChartTitles(oldIndex, newIndex),
              ),
            );
          }),

      // フローティングボタン
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewChartTitle,
        tooltip: 'チャート作成',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// チャートタイトルが書かれたカード
class _ChartTitleCard extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback? playButtonOnPressed;
  final VoidCallback? editButtonOnPressed;
  final VoidCallback? deleteButtonOnPressed;
  final VoidCallback? cardOnTap;

  const _ChartTitleCard({
    super.key,
    required this.index,
    required this.title,
    required this.playButtonOnPressed,
    this.editButtonOnPressed,
    this.deleteButtonOnPressed,
    this.cardOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      child: ListTile(
        title: Text(title),
        trailing: Wrap(
          children: [
            if (playButtonOnPressed != null)
              IconButton(
                icon: const Icon(Icons.play_circle),
                onPressed: playButtonOnPressed,
              ),
            if (editButtonOnPressed != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: editButtonOnPressed,
              ),
            if (deleteButtonOnPressed != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: deleteButtonOnPressed,
              ),
            SizedBox(width: 10),
          ],
        ),
        onTap: cardOnTap,
      ),
    );
  }
}
