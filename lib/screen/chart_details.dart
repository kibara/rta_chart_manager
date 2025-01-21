import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/dialog/dialog_utils.dart';
import 'package:rta_chart_manager/component/icons/icon_type.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';
import 'package:rta_chart_manager/database/models/chart_detail_model.dart';
import 'package:rta_chart_manager/database/models/chapter_summary_model.dart';

class ChartDetails extends StatefulWidget {
  const ChartDetails({super.key, required this.chapterSummary});

  final ChapterSummaryModel chapterSummary;

  // ステートを定義する
  @override
  State<ChartDetails> createState() => _ChartDetailsState();
}

class _ChartDetailsState extends State<ChartDetails> {
  late final Box<ChapterSummaryModel> _chapterSummaryBox;
  late final Box<ChartDetailModel> _chartDetailBox;
  late final List<ChapterSummaryModel> _chapterSummaryList;
  late final List<ChartDetailModel> _detailList;
  late final String _chartId;
  int currentPage = 0;
  Text currentPageTitle = Text('');

  @override
  void initState() {
    // chartId
    _chartId = widget.chapterSummary.chartId;

    // currentPage
    currentPage = widget.chapterSummary.orderIndex;

    // chapterSummary
    _chapterSummaryBox =
        KvsUtils.getBox<ChapterSummaryModel>(Collections.chapterSummary);
    _chapterSummaryList = List.from(
        _chapterSummaryBox.values.where((s) => s.chartId == _chartId));

    // chartDetail
    _chartDetailBox =
        KvsUtils.getBox<ChartDetailModel>(Collections.chartDetails);
    _detailList =
        List.from(_chartDetailBox.values.where((d) => d.chartId == _chartId));

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
    });
  }

  void _addActionItem() async {
    String? actionText = await DialogUtils.showEditingDialog(context, '');
    if (actionText != null) {
      ActionItemModel actionItem = ActionItemModel(
        actionText,
        IconType.buy,
        _detailList[currentPage].actionItems.length,
      );

      setState(() {
        _detailList[currentPage].actionItems.add(actionItem);
        _detailList[currentPage].save();
      });
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
      body: Center(
          child: PageView.builder(
        controller: pageController,
        onPageChanged: (index) => _setCurrentPage(index),
        itemCount: _detailList.length,
        itemBuilder: (context, index) {
          ChartDetailModel detailModel =
              _detailList.where((d) => d.orderIndex == index).first;

          return _DetailPage(actionItems: detailModel.actionItems);
        },
      )),
      floatingActionButton: FloatingActionButton(onPressed: _addActionItem),
    );
  }
}

class _DetailPage extends StatelessWidget {
  final List<ActionItemModel> actionItems;

  const _DetailPage({
    required this.actionItems,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: actionItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: IconType.getIcon(actionItems[index].iconType),
          title: Text(actionItems[index].text),
        );
      },
    );
  }
}
