import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';

class ChartDetails extends StatefulWidget {
  const ChartDetails({super.key, required this.title});

  final String title;

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
  late final Box _chartDetailBox;

  @override
  void initState() {
    _chartDetailBox = KvsUtils.getBox(Collections.chartDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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