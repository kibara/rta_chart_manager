import 'package:hive_flutter/hive_flutter.dart';
import 'package:rta_chart_manager/database/collections.dart';
import 'package:rta_chart_manager/database/kvs_utils.dart';
import 'package:rta_chart_manager/database/models/chart_title_model.dart';

class ChartRepository {
  /// Box
  static late final Box<ChartTitleModel> _chartTitleBox;

  /// Models List
  static late final List<ChartTitleModel> _chartTitles;

  /// initialize
  static bool initialized = false;

  /// 初期化
  static void init() {
    if (!initialized) {
      // チャート
      _chartTitleBox =
          KvsUtils.getBox<ChartTitleModel>(Collections.chartTitles);
      _chartTitles = _chartTitleBox.values.toList();
      _chartTitles.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      // 初期化済み
      initialized = true;
    }
  }

  /// Box取得
  static Box<ChartTitleModel> getBox() {
    return _chartTitleBox;
  }

  /// チャート一覧取得
  static List<ChartTitleModel> getList() {
    return _chartTitles;
  }

  /// index番号でチャート取得
  static ChartTitleModel getAt(int index) {
    return _chartTitles[index];
  }

  static ChartTitleModel? getId(String id) {
    return _chartTitleBox.get(id);
  }

  /// チャートの個数を取得
  static int getLength() {
    return _chartTitles.length;
  }

  /// チャートの追加
  static void add(ChartTitleModel chartTitleModel) {
    _chartTitles.add(chartTitleModel);
    _chartTitleBox.put(chartTitleModel.id, chartTitleModel);
  }

  /// チャートの削除
  static void delete(int index) {
    var target = _chartTitles.removeAt(index);
    _chartTitleBox.delete(target.id);
  }

  /// 並び替え
  static void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    var item = _chartTitles.removeAt(oldIndex);
    _chartTitles.insert(newIndex, item);

    for (var i = 0; i < _chartTitles.length; i++) {
      _chartTitles[i].orderIndex = i;
      _chartTitles[i].save();
    }
  }
}
