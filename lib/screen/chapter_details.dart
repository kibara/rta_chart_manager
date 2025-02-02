import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/component/extension/datetime_extension.dart';
import 'package:rta_chart_manager/component/extension/duration_extension.dart';
import 'package:rta_chart_manager/component/icons/action_type.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';
import 'package:rta_chart_manager/database/models/chapter_detail_model.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ChapterDetails extends StatefulWidget {
  const ChapterDetails({super.key, required this.chapterSummary});

  final ChapterSummaryModel chapterSummary;

  // ステートを定義する
  @override
  State<ChapterDetails> createState() => _ChapterDetailsState();
}

class _ChapterDetailsState extends State<ChapterDetails> {
  late final Box<ChapterSummaryModel> _chapterSummaryBox;
  late final Box<ChapterDetailModel> _chapterDetailBox;
  late final List<ChapterSummaryModel> _chapterSummaryList;
  late final Map<String, ChapterDetailModel> _detailMap;
  late final String _chartId;
  late int currentPage;
  late String currentSummaryId;
  Text currentPageTitle = Text('');

  @override
  void initState() {
    // chartId
    _chartId = widget.chapterSummary.chartId;

    // currentPage
    currentPage = widget.chapterSummary.orderIndex;
    currentSummaryId = widget.chapterSummary.id;

    // chapterSummary
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);
    _chapterSummaryList = List.from(
        _chapterSummaryBox.values.where((s) => s.chartId == _chartId));

    // chapterDetail
    _chapterDetailBox =
        KvsUtils.getBox<ChapterDetailModel>(Collections.chapterDetails);
    _detailMap = {
      for (var element
          in _chapterDetailBox.values.where((d) => d.chartId == _chartId))
        element.summaryId: element
    };

    super.initState();
  }

  String _getCurrentPageTitle() {
    return _chapterSummaryList
        .where((s) => s.orderIndex == currentPage)
        .first
        .title;
  }

  void _setCurrentPage(int index) {
    setState(() {
      currentPage = index;
      currentSummaryId = _chapterSummaryList[currentPage].id;
    });
  }

  void _addActionItem() async {
    List<String>? inputAction = await DialogUtils.showTitleAndSelectionDialog(
      context,
      'やること',
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
    PageController pageController = PageController(initialPage: currentPage);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_getCurrentPageTitle()),
      ),
      body: ValueListenableBuilder(
          valueListenable: _chapterDetailBox.listenable(),
          builder: (context, box, widget) => PageView.builder(
                controller: pageController,
                onPageChanged: (index) => _setCurrentPage(index),
                itemCount: _detailMap.length,
                itemBuilder: (context, index) {
                  return _DetailPage(chapter: _detailMap[currentSummaryId]!);
                },
              )),
      floatingActionButton: FloatingActionButton(onPressed: _addActionItem),
    );
  }
}

class _DetailPage extends StatelessWidget {
  final ChapterDetailModel chapter;

  const _DetailPage({required this.chapter});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 区間予定タイム
        ListTile(
          leading: Icon(Icons.timer_outlined),
          title: Text('区間予定タイム ${chapter.estimateTime}'),
          trailing: IconButton(
            onPressed: () => _editEstimateTime(context),
            icon: Icon(Icons.edit_outlined),
          ),
        ),
        // TODO: 区間実績タイム
        // アクションアイテムリスト
        Flexible(
          child: ListView.builder(
            itemCount: chapter.actionItems.length,
            itemBuilder: (context, index) {
              var actionItem = chapter.actionItems[index];
              if (actionItem.actionType == ActionType.section.id) {
                return ListTile(
                  leading: ActionType.getIconByInt(actionItem.actionType),
                  title: Text(actionItem.text),
                  titleTextStyle: TextStyle(fontSize: 20),
                  minVerticalPadding: 16,
                  tileColor: const Color.fromARGB(200, 255, 240, 200),
                );
              } else {
                return ListTile(
                  leading: ActionType.getIconByInt(actionItem.actionType),
                  title: Text(actionItem.text),
                  titleTextStyle: TextStyle(fontSize: 16),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
