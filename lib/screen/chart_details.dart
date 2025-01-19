import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';
import 'package:rta_chart_manager/database/models/chart_detail_model.dart';
import 'package:rta_chart_manager/database/models/chart_summary_model.dart';

class ChartDetails extends StatefulWidget {
  const ChartDetails({super.key, required this.chartSummary});

  final ChartSummaryModel chartSummary;

  // ステートを定義する
  @override
  State<ChartDetails> createState() => _ChartDetailsState();
}

class _ChartDetailsState extends State<ChartDetails> {
  late final Box<ChartSummaryModel> _chartSummaryBox;
  late final Box<ChartDetailModel> _chartDetailBox;
  late final List<ChartSummaryModel> _chartSummaryList;
  late final List<ChartDetailModel> _detailList;
  late final String _chartId;
  int currentPage = 0;

  @override
  void initState() {
    // chartId
    _chartId = widget.chartSummary.chartId;

    // currentPage
    currentPage = widget.chartSummary.orderIndex;

    // chartSummary
    _chartSummaryBox =
        KvsUtils.getBox<ChartSummaryModel>(Collections.chartSummary);
    _chartSummaryList =
        List.from(_chartSummaryBox.values.where((s) => s.chartId == _chartId));

    // chartDetail
    _chartDetailBox =
        KvsUtils.getBox<ChartDetailModel>(Collections.chartDetails);
    _detailList =
        List.from(_chartDetailBox.values.where((d) => d.chartId == _chartId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: currentPage);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.chartSummary.title),
      ),
      body: Center(
          child: PageView.builder(
        controller: pageController,
        itemCount: _detailList.length,
        itemBuilder: (context, index) {
          ChartDetailModel detailModel =
              _detailList.where((d) => d.orderIndex == index).first;

          return ListView.builder(
              itemCount: detailModel.actionItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person_pin_circle),
                  title: Text(detailModel!.actionItems[index].text),
                );
              });
        },
      )),
      floatingActionButton: FloatingActionButton(onPressed: () {
        ActionItemModel actionItem = ActionItemModel('み', 1, 0);

        setState(() {
          _detailList[currentPage].actionItems.add(actionItem);
          _detailList[currentPage].save();
        });
      }),
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
    return Text('abc');
  }
}
