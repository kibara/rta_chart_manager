import 'package:hive_flutter/hive_flutter.dart';

class KvsUtils {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static Future<Box> openBox<T>(String boxName) {
    return Hive.openBox<T>(boxName);
  }

  static getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  static registerAdapter<T>(TypeAdapter adapter) {
    Hive.registerAdapter(adapter);
  }
}
