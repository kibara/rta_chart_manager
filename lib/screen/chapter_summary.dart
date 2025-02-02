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

  void _addChapterDetail() async {
    String? summaryTitle = await DialogUtils.showEditingDialog(
        context, 'part ${_chapterSummary.length + 1}');
    if (summaryTitle != null) {
      ChapterSummaryModel newChapterSummaryModel = ChapterSummaryModel(
        widget.chartTitle.id,
        summaryTitle,
        _chapterSummary.length,
      );

      _chapterSummary.add(newChapterSummaryModel);
      _chapterSummaryBox.add(newChapterSummaryModel);

      ChapterDetailModel newChapterDetailModel = ChapterDetailModel(
        widget.chartTitle.id,
        newChapterSummaryModel.id,
      );
      _chapterDetailBox.add(newChapterDetailModel);
    }
  }

  /// チャートタイトルの並び替えイベント
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
                return Card(
                  key: Key(_chapterSummary[index].id),
                  child: ListTile(
                    title: Text(_chapterSummary[index].title),
                    trailing: Wrap(children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => {},
                      ),
                    ]),
                    onTap: () => _navChapterDetail(index, context),
                  ),
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
        tooltip: '新規作成',
        child: const Icon(Icons.add),
      ),
    );
  }
}
