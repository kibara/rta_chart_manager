import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/component/util/id_generator.dart';

part 'chart_play_time_model.g.dart';

@HiveType(typeId: 5)
class ChartPlayTimeModel extends HiveObject {
  @HiveField(0)
  String id = IdGenerator.genUUIDv4();

  @HiveField(1)
  String chartId;

  @HiveField(2)
  String playTitle = '';

  @HiveField(3)
  Duration playTime = Duration(seconds: 0);

  /// summaryId: lapTime
  @HiveField(4)
  Map<String, Duration> lapTimes = {};

  @HiveField(5)
  DateTime startDateTime = DateTime.now();

  ChartPlayTimeModel(this.chartId);
}
