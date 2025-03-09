import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/buttons/floating_action.dart';
import 'package:rta_chart_manager/component/cards/chart_title_card.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/component/stop_watch/chart_timer.dart';
import 'package:rta_chart_manager/component/styles/color_theme.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';
import 'package:rta_chart_manager/database/repository/chart_repository.dart';
import 'package:rta_chart_manager/routes/route_manager.dart';

class ChartTitles extends StatefulWidget {
  const ChartTitles({super.key, required this.title});

  final String title;

  // ステートを定義する
  @override
  State<ChartTitles> createState() => _ChartTitlesState();
}

class _ChartTitlesState extends State<ChartTitles> {
  late final Box<ChapterSummaryModel> _chapterSummaryBox;

  @override
  void initState() {
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);

    ChartRepository.init();

    super.initState();
  }

  /// チャート新規作成
  void _addNewChart() async {
    final String? newChartTitle =
        await DialogUtils.showEditingDialog(context, 'no title chart');

    if (newChartTitle != null) {
      ChartTitleModel newChart = ChartTitleModel(
        newChartTitle,
        ChartRepository.getLength(),
      );

      ChartRepository.add(newChart);
    }
  }

  /// チャートタイトルの編集
  void _editChartTitle(int index) async {
    var model = ChartRepository.getAt(index);
    final String? editedChartTitle =
        await DialogUtils.showEditingDialog(context, model.title);

    if (editedChartTitle != null) {
      model.title = editedChartTitle;
      model.save();
    }
  }

  /// チャート削除
  void _deleteChart(int index) {
    ChartRepository.delete(index);
  }

  /// チャート詳細に遷移
  void _navChapterSummary(int index) {
    RouteManager.navChapterSummary(
      chartId: ChartRepository.getAt(index).id,
    );
  }

  /// チャートをプレイする
  void _playChart(int index) {
    var chartTitleModel = ChartRepository.getAt(index);
    ChapterSummaryModel? firstChapter = _chapterSummaryBox.values
        .where((s) => s.chartId == chartTitleModel.id && s.orderIndex == 0)
        .firstOrNull;

    if (firstChapter != null) {
      RouteManager.navChapterDetail(
        chartId: chartTitleModel.id,
        chapterSummaryId: firstChapter.id,
        isEdit: false,
      );

      ChartTimer.reset();
      ChartTimer.start();
    }
  }

  // アプリの画面構成と挙動を構成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        backgroundColor: ColorTheme.primaryColor(context),
        title: Text(widget.title),
      ),

      // Content Body
      body: ValueListenableBuilder(
          valueListenable: ChartRepository.getBox().listenable(),
          builder: (context, box, widget) {
            return Center(
              child: ReorderableListView.builder(
                itemCount: ChartRepository.getLength(),
                itemBuilder: (BuildContext context, int index) {
                  var model = ChartRepository.getAt(index);
                  return ChartTitleCard(
                    key: Key(model.id),
                    index: index,
                    title: model.title,
                    playButtonOnPressed: () => _playChart(index),
                    editButtonOnPressed: () => _editChartTitle(index),
                    deleteButtonOnPressed: () => _deleteChart(index),
                    cardOnTap: () => _navChapterSummary(index),
                  );
                },
                onReorder: (oldIndex, newIndex) =>
                    ChartRepository.reorder(oldIndex, newIndex),
              ),
            );
          }),

      // フローティングボタン
      floatingActionButton: FloatingAction.addButton(
        context,
        onPressed: _addNewChart,
        tooltip: 'チャート追加',
      ),
    );
  }
}
