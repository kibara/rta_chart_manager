import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';

class ChartSummary extends StatefulWidget {
  const ChartSummary({super.key, required this.title});

  final String title;

  // ステートを定義する
  @override
  State<ChartSummary> createState() => _ChartDetailsState();
}

class _ChartDetailsState extends State<ChartSummary> {
  // ステートで保持する値
  // {
  //     "chart_title": [{ * chart_part1_json * }, { * chart_part2_json * }],
  //     ...
  // }
  late final Box _chartDetailBox;
  late final List<dynamic> _chart;
  late final String _chartTitle;

  @override
  void initState() {
    _chartDetailBox = KvsUtils.getBox(Collections.chartDetails);
    _chartTitle = widget.title;
    _chart = List.from(_chartDetailBox.get(_chartTitle));
    super.initState();
  }

  /// チャート詳細に遷移
  void _navChartDetail(int index, BuildContext context) {
    //
    print("on tap card $index");
    context.push('/chart_detail', extra: _chartTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_chartTitle),
      ),
      body: ValueListenableBuilder(
        valueListenable: _chartDetailBox.listenable(keys: [_chartTitle]),
        builder: (context, box, widget) {
          return Center(
            child: ListView.builder(
              itemCount: _chart.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_chart[index].title ?? 'no title'),
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
    );
  }
}
