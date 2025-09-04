import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static final _storage = new FlutterSecureStorage();

  static Future<void> saveData(String key, String data) async {
    await _storage.write(key: key, value: data);
    print('$key의 데이터 $data를 저장했습니다.');
  }

  static void saveBoolArrayData(String key, List<bool> data) async {
    await _storage.write(key: key, value: jsonEncode(data));
    print('$key의 데이터(배열) $data를 저장했습니다.');
  }

  static void deleteData(String key) async {
    await _storage.delete(key: key);
    print('$key의 데이터를 삭제했습니다.');
  }

  static void deleteAllData() async {
    await _storage.deleteAll();
    print('데이터를 모두 삭제했습니다.');
  }

  static Future<String?> readData(String key) async {
    String? value = await _storage.read(key: key);
    print('$key의 데이터를 불러왔습니다.');
    return value;
  }

  static Future<bool?> readBoolData(String key) async {
    String? value = await _storage.read(key: key);
    final result = value == "true"
        ? true
        : value == "false"
        ? false
        : null;
    print('$key의 데이터를 불러왔습니다.');
    return result;
  }

  static Future<List<bool>?> readBoolArrayData(String key) async {
    String? data = await _storage.read(key: key);
    List<bool>? value = [];
    if (data != null) {
      value = jsonDecode(data) as List<bool>;
    }

    print('$key의 데이터를 불러왔습니다.');
    return value;
  }
}
