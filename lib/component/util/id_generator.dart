import 'package:uuid/uuid.dart';

class IdGenerator {
  static String genUUIDv4() {
    return Uuid().v4();
  }
}
