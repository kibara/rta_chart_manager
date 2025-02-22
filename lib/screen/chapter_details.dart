import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/component/extension/datetime_extension.dart';
import 'package:rta_chart_manager/component/extension/duration_extension.dart';
import 'package:rta_chart_manager/component/extension/string_extension.dart';
import 'package:rta_chart_manager/component/icons/action_type.dart';
import 'package:rta_chart_manager/component/stop_watch/chart_timer.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';
import 'package:rta_chart_manager/database/models/chapter_detail_model.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:rta_chart_manager/database/models/chart_play_time_model.dart';

class ChapterDetails extends StatefulWidget {
  const ChapterDetails({
    super.key,
    required this.chartTitleId,
    required this.chapterSummaryId,
    required this.isEditMode,
  });

  final String chartTitleId;
  final String chapterSummaryId;
  final bool isEditMode;

  // ステートを定義する
  @override
  State<ChapterDetails> createState() => _ChapterDetailsState();
}

class _ChapterDetailsState extends State<ChapterDetails> {
  late final Box<ChapterSummaryModel> _chapterSummaryBox;
  late final Box<ChapterDetailModel> _chapterDetailBox;
  late final Box<ChartPlayTimeModel> _chartPlayTimeBox;
  late final List<ChapterSummaryModel> _chapterSummaryList;
  late final Map<String, ChapterDetailModel> _detailMap;
  late int currentPage;
  late String currentSummaryId;
  late String? beforeSummaryId;
  late String? nextSummaryId;
  late final List<ChartPlayTimeModel> _playHistories;
  late final ChartPlayTimeModel currentChartPlayTime;

  @override
  void initState() {
    // chapterSummary
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);
    _chapterSummaryList = List.from(_chapterSummaryBox.values
        .where((s) => s.chartId == widget.chartTitleId));

    // chapterDetail
    _chapterDetailBox =
        KvsUtils.getBox<ChapterDetailModel>(Collections.chapterDetails);
    _detailMap = {
      for (var element in _chapterDetailBox.values
          .where((d) => d.chartId == widget.chartTitleId))
        element.summaryId: element
    };

    // chartPlayTime
    _chartPlayTimeBox =
        KvsUtils.getBox<ChartPlayTimeModel>(Collections.chartPlayTimes);
    _playHistories = _chartPlayTimeBox.values
        .where((p) => p.chartId == widget.chartTitleId)
        .toList();

    // プレイモードなら記録をつくる
    if (!widget.isEditMode) {
      currentChartPlayTime = ChartPlayTimeModel(widget.chartTitleId);
      _playHistories.add(currentChartPlayTime);
      _chartPlayTimeBox.put(currentChartPlayTime.id, currentChartPlayTime);
    }

    // currentPage
    currentPage = _chapterSummaryBox.get(widget.chapterSummaryId)!.orderIndex;
    currentSummaryId = widget.chapterSummaryId;

    // NextPage
    nextSummaryId = _getNextSummaryId();
    beforeSummaryId = _getBeforeSummaryId();

    super.initState();
  }

  String _getCurrentPageTitle() {
    return _chapterSummaryList
        .where((s) => s.orderIndex == currentPage)
        .first
        .title;
  }

  String? _getNextSummaryId() {
    if (_chapterSummaryList.length == currentPage + 1) return null;
    return _chapterSummaryList
        .where((s) => s.orderIndex == currentPage + 1)
        .firstOrNull
        ?.id;
  }

  String? _getBeforeSummaryId() {
    if (currentPage == 0) return null;
    return _chapterSummaryList
        .where((s) => s.orderIndex == currentPage - 1)
        .firstOrNull
        ?.id;
  }

  void _addActionItem() async {
    List<String>? inputAction = await DialogUtils.showTitleAndSelectionDialog(
      context,
      'やること',
      ActionType.section.id,
      ActionType.getDropdownMenuItemList(),
    );

    if (inputAction != null) {
      ActionItemModel actionItem = ActionItemModel(
          inputAction[0],
          int.parse(inputAction[1]),
          _detailMap[currentSummaryId]!.actionItems.length);

      _detailMap[currentSummaryId]!.actionItems.add(actionItem);
      _detailMap[currentSummaryId]!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton? addActionButton = widget.isEditMode
        ? FloatingActionButton(
            tooltip: 'アクション追加',
            onPressed: _addActionItem,
            child: const Icon(Icons.add),
          )
        : null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_getCurrentPageTitle()),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              // FIXME: プレイモードのときはチャートトップに行くべきだと思う
              ChartTimer.stop();
              ChartTimer.reset();
              context.goNamed(
                'chapter_summary',
                pathParameters: {
                  'chartId': widget.chartTitleId,
                },
              );
            },
            icon: BackButtonIcon()),
      ),
      body: ValueListenableBuilder(
          valueListenable: _chapterDetailBox.listenable(),
          builder: (context, box, _) => _DetailPage(
                chapter: _detailMap[currentSummaryId]!,
                isEditMode: widget.isEditMode,
              )),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            if (beforeSummaryId != null)
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary),
                onPressed: () => {
                  context.goNamed(
                    'chapter_detail',
                    pathParameters: {
                      'chartId': widget.chartTitleId,
                      'summaryId': beforeSummaryId!,
                    },
                    queryParameters: {'editMode': "${widget.isEditMode}"},
                  )
                },
                child: Text('< Before'),
              )),
            if (nextSummaryId != null)
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary),
                onPressed: () {
                  if (!widget.isEditMode) {
                    // プレイモードならば、次のチャプターへ遷移する際にラップタイムを記録する
                    // そのラップタイムを、そのチャプターの実績時間とする
                    String lapTime = ChartTimer.addLap();
                    currentChartPlayTime.lapTimes.addEntries({
                      currentSummaryId: lapTime.conv2Duration(),
                    }.entries);
                    currentChartPlayTime.save();
                  }

                  context.goNamed(
                    'chapter_detail',
                    pathParameters: {
                      'chartId': widget.chartTitleId,
                      'summaryId': nextSummaryId!,
                    },
                    queryParameters: {'editMode': "${widget.isEditMode}"},
                  );
                },
                child: Text('Next >'),
              )),
          ],
        ),
      ),
      floatingActionButton: addActionButton,
    );
  }
}

/// アクションアイテムのリストを表示する画面構成
class _DetailPage extends StatelessWidget {
  final ChapterDetailModel chapter;
  final bool isEditMode;

  const _DetailPage({required this.chapter, required this.isEditMode});

  void _editEstimateTime(BuildContext context) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: true,
      onConfirm: (date) {
        chapter.estimateTime = date.conv2Duration();
        chapter.save();
      },
      currentTime: chapter.estimateTime.conv2Datetime(),
      locale: LocaleType.en,
    );
  }

  void _editActionItem(BuildContext context, int index) async {
    List<String>? inputAction = await DialogUtils.showTitleAndSelectionDialog(
      context,
      chapter.actionItems[index].text,
      chapter.actionItems[index].actionType,
      ActionType.getDropdownMenuItemList(),
    );

    if (inputAction != null) {
      chapter.actionItems[index].text = inputAction[0];
      chapter.actionItems[index].actionType = int.parse(inputAction[1]);
      chapter.save();
    }
  }

  void _deleteActionItem(int index) {
    chapter.actionItems.removeAt(index);
    chapter.save();
  }

  /// アクションアイテムの並び替えイベント
  void _reorderActionItem(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ActionItemModel item = chapter.actionItems.removeAt(oldIndex);
    chapter.actionItems.insert(newIndex, item);

    for (var i = 0; i < chapter.actionItems.length; i++) {
      chapter.actionItems[i].orderIndex = i;
    }
    chapter.save();
  }

  ListTile _actionItemListBuilder(BuildContext context, int index) {
    ActionItemModel actionItem = chapter.actionItems[index];
    bool isSection = actionItem.actionType == ActionType.section.id;
    double fontSize = isSection ? 24.0 : 16.0;
    double padding = isSection ? 8.0 : 4.0;
    Color? titleColor =
        isSection ? const Color.fromARGB(200, 255, 240, 200) : null;

    return ListTile(
      key: Key(actionItem.id),
      leading: ActionType.getIconByInt(actionItem.actionType),
      title: Text(actionItem.text),
      titleTextStyle: TextStyle(fontSize: fontSize),
      trailing: Wrap(children: [
        if (isEditMode)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editActionItem(context, index),
          ),
        if (isEditMode)
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteActionItem(index),
          ),
        SizedBox(width: 10),
      ]),
      minVerticalPadding: padding,
      tileColor: titleColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    IconButton? editEstimateTimeButton = isEditMode
        ? IconButton(
            onPressed: () => _editEstimateTime(context),
            icon: Icon(Icons.edit_outlined),
          )
        : null;

    return Column(
      children: [
        // 現在の計測タイム
        if (!isEditMode)
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: ChartTimer(),
          ),
        // 区間予定タイム
        Container(
            color: Theme.of(context).colorScheme.surface,
            child: ListTile(
              leading: Icon(Icons.timer_outlined),
              title: Text('区間予定タイム ${chapter.estimateTime}'),
              trailing: editEstimateTimeButton,
            )),
        // TODO: 区間実績タイム
        // アクションアイテムリスト
        if (isEditMode)
          Flexible(
            child: ReorderableListView.builder(
              itemCount: chapter.actionItems.length,
              itemBuilder: (context, index) =>
                  _actionItemListBuilder(context, index),
              onReorder: (int oldIndex, int newIndex) =>
                  _reorderActionItem(oldIndex, newIndex),
            ),
          )
        else
          Flexible(
            child: ListView.builder(
              itemCount: chapter.actionItems.length,
              itemBuilder: (context, index) =>
                  _actionItemListBuilder(context, index),
            ),
          )
      ],
    );
  }
}
