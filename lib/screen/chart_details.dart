import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
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
  // ステートで保持する値
  // {
  //     "chart_title": [{ * chart_part1_json * }, { * chart_part2_json * }],
  //     ...
  // }
  late final Box<ChartDetailModel> _chartDetailBox;

  @override
  void initState() {
    _chartDetailBox =
        KvsUtils.getBox<ChartDetailModel>(Collections.chartDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.chartSummary.title),
      ),
      body: ValueListenableBuilder(
        valueListenable: _chartDetailBox.listenable(),
        builder: (context, box, widget) {
          return Center(
            child: Text("aaa"),
          );
        },
      ),
    );
  }
}
