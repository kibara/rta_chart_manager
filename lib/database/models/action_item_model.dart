import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/util/id_generator.dart';

part 'action_item_model.g.dart';

@HiveType(typeId: 3)
class ActionItemModel extends HiveObject {
  @HiveField(0)
  String id = IdGenerator.genUUIDv4();

  @HiveField(1)
  int orderIndex;

  @HiveField(2)
  String text;

  @HiveField(3)
  int iconType;

  ActionItemModel(this.text, this.iconType, this.orderIndex);
}
