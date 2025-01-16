import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/util/id_generator.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';

part 'chart_detail_model.g.dart';

@HiveType(typeId: 2)
class ChartDetailModel extends HiveObject {
  @HiveField(0)
  String id = IdGenerator.genUUIDv4();

  @HiveField(3)
  String chartId;

  @HiveField(6)
  String summaryId;

  @HiveField(1)
  int orderIndex;

  @HiveField(2)
  String title;

  /// この区間の予定タイム
  @HiveField(4)
  Duration estimateTime = Duration(seconds: 0);

  @HiveField(5)
  List<ActionItemModel> actionItems = [];

  ChartDetailModel(this.chartId, this.summaryId, this.title, this.orderIndex);
}
