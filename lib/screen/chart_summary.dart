import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chart_detail_model.dart';
import 'package:rta_chart_manager/database/models/chart_summary_model.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';

class ChartSummary extends StatefulWidget {
  const ChartSummary({super.key, required this.chartTitle});

  final ChartTitleModel chartTitle;

  // ステートを定義する
  @override
  State<ChartSummary> createState() => _ChartDetailsState();
}

class _ChartDetailsState extends State<ChartSummary> {
  late final Box<ChartDetailModel> _chartDetailBox;

  late final Box<ChartSummaryModel> _chartSummaryBox;
  late final List<ChartSummaryModel> _chartSummary;
  late final String _chartTitle;

  @override
  void initState() {
    _chartDetailBox =
        KvsUtils.getBox<ChartDetailModel>(Collections.chartDetails);
    _chartSummaryBox =
        KvsUtils.getBox<ChartSummaryModel>(Collections.chartSummary);
    _chartTitle = widget.chartTitle.title;
    _chartSummary = List.from(_chartSummaryBox.values.where(
        (ChartSummaryModel model) => model.chartId == widget.chartTitle.id));

    super.initState();
  }

  void _addChartDetail() {
    ChartSummaryModel newChartSummaryModel = ChartSummaryModel(
      widget.chartTitle.id,
      '無題2',
      _chartSummary.length,
    );

    _chartSummary.add(newChartSummaryModel);
    _chartSummaryBox.add(newChartSummaryModel);

    ChartDetailModel newChartDetailModel = ChartDetailModel(
      widget.chartTitle.id,
      newChartSummaryModel.id,
      '無題',
      _chartDetailBox.values.length,
    );
    _chartDetailBox.add(newChartDetailModel);
  }

  /// チャート詳細に遷移
  void _navChartDetail(int index, BuildContext context) {
    context.push('/chart_detail', extra: _chartSummary[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_chartTitle),
      ),
      body: ValueListenableBuilder(
        valueListenable: _chartSummaryBox.listenable(),
        builder: (context, box, widget) {
          return Center(
            child: ListView.builder(
              itemCount: _chartSummary.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_chartSummary[index].title),
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
                    onTap: () => _navChartDetail(index, context),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addChartDetail,
        tooltip: '新規作成',
        child: const Icon(Icons.add),
      ),
    );
  }
}
