import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/util/id_generator.dart';

part 'chart_title_model.g.dart';

@HiveType(typeId: 0)
class ChartTitleModel extends HiveObject {
  @HiveField(0)
  String id = IdGenerator.genUUIDv4();

  @HiveField(1)
  int orderIndex;

  @HiveField(2)
  String title;

  ChartTitleModel(this.title, this.orderIndex);
}
