import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/util/id_generator.dart';

part 'chapter_summary_model.g.dart';

@HiveType(typeId: 1)
class ChapterSummaryModel extends HiveObject {
  @HiveField(0)
  String id = IdGenerator.genUUIDv4();

  @HiveField(3)
  String chartId;

  @HiveField(1)
  int orderIndex;

  @HiveField(2)
  String title;

  ChapterSummaryModel(this.chartId, this.title, this.orderIndex);
}
