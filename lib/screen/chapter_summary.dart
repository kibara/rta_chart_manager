import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chapter_detail_model.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';

class ChapterSummary extends StatefulWidget {
  const ChapterSummary({super.key, required this.chartTitle});

  final ChartTitleModel chartTitle;

  // ステートを定義する
  @override
  State<ChapterSummary> createState() => _ChapterDetailsState();
}

class _ChapterDetailsState extends State<ChapterSummary> {
  late final Box<ChapterDetailModel> _chapterDetailBox;

  late final Box<ChapterSummaryModel> _chapterSummaryBox;
  late final List<ChapterSummaryModel> _chapterSummary;
  late final String _chartTitle;

  @override
  void initState() {
    _chapterDetailBox =
        KvsUtils.getBox<ChapterDetailModel>(Collections.chapterDetails);
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);
    _chartTitle = widget.chartTitle.title;
    _chapterSummary = List.from(_chapterSummaryBox.values.where(
        (ChapterSummaryModel model) => model.chartId == widget.chartTitle.id));
    _chapterSummary.sort((a, b) => a.orderIndex > b.orderIndex ? 1 : -1);

    super.initState();
  }

  /// チャプターの追加
  void _addChapterDetail() async {
    String? summaryTitle = await DialogUtils.showEditingDialog(
        context, 'chapter ${_chapterSummary.length + 1}');
    if (summaryTitle != null) {
      ChapterSummaryModel newChapterSummaryModel = ChapterSummaryModel(
        widget.chartTitle.id,
        summaryTitle,
        _chapterSummary.length,
      );

      _chapterSummary.add(newChapterSummaryModel);
      _chapterSummaryBox.put(newChapterSummaryModel.id, newChapterSummaryModel);

      ChapterDetailModel newChapterDetailModel = ChapterDetailModel(
        widget.chartTitle.id,
        newChapterSummaryModel.id,
      );
      _chapterDetailBox.put(newChapterDetailModel.id, newChapterDetailModel);
    }
  }

  /// チャートタイトルの編集
  void _editChapterTitle(int index) async {
    final String? editedChapterTitle = await DialogUtils.showEditingDialog(
        context, _chapterSummary[index].title);

    if (editedChapterTitle != null) {
      _chapterSummary[index].title = editedChapterTitle;
      _chapterSummary[index].save();
    }
  }

  /// チャートの削除
  void _deleteChartTitle(int index) {
    ChapterSummaryModel chapterSummaryModel = _chapterSummary[index];
    _chapterSummary.removeAt(index);
    _chapterSummaryBox.delete(chapterSummaryModel.id);
    _chapterDetailBox.values
        .where((v) => v.summaryId == chapterSummaryModel.id)
        .first
        .delete();
  }

  /// チャートサマリの並び替えイベント
  void _reorderChapterTitle(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ChapterSummaryModel item = _chapterSummary.removeAt(oldIndex);
    _chapterSummary.insert(newIndex, item);

    for (var i = 0; i < _chapterSummary.length; i++) {
      _chapterSummary[i].orderIndex = i;
      _chapterSummary[i].save();
    }
  }

  /// チャート詳細に遷移
  void _navChapterDetail(int index, BuildContext context) {
    context.push('/chapter_detail', extra: _chapterSummary[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_chartTitle),
      ),
      body: ValueListenableBuilder(
        valueListenable: _chapterSummaryBox.listenable(),
        builder: (context, box, widget) {
          return Center(
            child: ReorderableListView.builder(
              itemCount: _chapterSummary.length,
              itemBuilder: (context, index) {
                return _ChapterSummaryCard(
                  key: Key(_chapterSummary[index].id),
                  chapterSummaryModel: _chapterSummary[index],
                  editButtonOnPressed: () => _editChapterTitle(index),
                  deleteButtonOnPressed: () => _deleteChartTitle(index),
                  cardOnTap: () => _navChapterDetail(index, context),
                );
              },
              onReorder: (int oldIndex, int newIndex) =>
                  _reorderChapterTitle(oldIndex, newIndex),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addChapterDetail,
        tooltip: 'チャプター作成',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ChapterSummaryCard extends StatelessWidget {
  final ChapterSummaryModel chapterSummaryModel;
  final VoidCallback? editButtonOnPressed;
  final VoidCallback? deleteButtonOnPressed;
  final VoidCallback? cardOnTap;

  const _ChapterSummaryCard({
    super.key,
    required this.chapterSummaryModel,
    this.editButtonOnPressed,
    this.deleteButtonOnPressed,
    this.cardOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      child: ListTile(
        title: Text(chapterSummaryModel.title),
        trailing: Wrap(children: [
          if (editButtonOnPressed != null)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: editButtonOnPressed,
            ),
          if (deleteButtonOnPressed != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteButtonOnPressed,
            ),
          SizedBox(width: 10),
        ]),
        onTap: cardOnTap,
      ),
    );
  }
}
