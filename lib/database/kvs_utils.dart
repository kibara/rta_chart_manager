import 'package:hive_flutter/hive_flutter.dart';

class KvsUtils {
  /// Hiveの初期化
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Hiveを閉じる
  static Future<void> close() async {
    await Hive.close();
  }

  /// Boxを開く
  /// アプリを開くタイミングで先に開いておく必要がある
  static Future<Box> openBox<T>(String boxName) {
    return Hive.openBox<T>(boxName);
  }

  /// Boxを取得する
  /// 事前にopenBoxしておく必要がある
  static getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// HiveAdapterを登録する
  /// openBoxの前に登録しておく必要がある
  static registerAdapter<T>(TypeAdapter<T> adapter) {
    Hive.registerAdapter<T>(adapter);
  }
}
