import 'package:hive_flutter/hive_flutter.dart';

class KvsUtils {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static Future<Box> openBox(String boxName) {
    return Hive.openBox(boxName);
  }

  static getBox(String boxName) {
    return Hive.box(boxName);
  }
}
