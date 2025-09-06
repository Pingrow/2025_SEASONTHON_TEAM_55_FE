import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pin_grow/model/region_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 생성될 파일 이름을 명시합니다.
part 'region_provider.g.dart';

@Riverpod(keepAlive: true)
class Region extends _$Region {
  @override
  Map<String, RegionModel>? build() {
    return null;
  }

  Future<void> getRegions() async {
    String jsonString = await rootBundle.loadString(
      'assets/region/regions.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    Map<String, RegionModel> regions = jsonMap.map((key, value) {
      return MapEntry(key, RegionModel.fromJson(value));
    });

    state = regions;
    print(
      "[DEBUG : getRegions] \n${regions[regions.keys.elementAt(0)]?.areas}",
    );
  }
}
