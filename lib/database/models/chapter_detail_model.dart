import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/util/id_generator.dart';
import 'package:rta_chart_manager/database/models/action_item_model.dart';

part 'chapter_detail_model.g.dart';

@HiveType(typeId: 2)
class ChapterDetailModel extends HiveObject {
  @HiveField(0)
  String id = IdGenerator.genUUIDv4();

  @HiveField(3)
  String chartId;

  @HiveField(6)
  String summaryId;

  @HiveField(1)
  int orderIndex;

  /// この区間の予定タイム
  @HiveField(4)
  Duration estimateTime = Duration(seconds: 0);

  @HiveField(5)
  List<ActionItemModel> actionItems = [];

  ChapterDetailModel(this.chartId, this.summaryId, this.orderIndex);
}
