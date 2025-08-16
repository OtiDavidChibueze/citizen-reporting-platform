import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_string.dart';

class LocalStorageService {
  static const String _boxName = AppString.boxName;

  final Box _box = Hive.box(_boxName);

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  Future<void> save(String key, String session) async {
    await _box.put(key, session);
  }

  String? get(String key) {
    return _box.get(key);
  }

  bool has(String key) {
    return _box.containsKey(key);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
