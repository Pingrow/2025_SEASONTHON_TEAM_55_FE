import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pin_grow/model/data_lists.dart';
import 'package:pin_grow/model/recommend_product_model.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_repository.g.dart';

@Riverpod(keepAlive: true)
ApiRepository apiRepository(Ref ref) {
  return ApiRepository();
}

class ApiRepository {
  //type은 policies, top10
  Future<List<dynamic>> fetchPolicy(
    String type,
    String? region,
    String? area,
  ) async {
    //final token = await SecureStorageManager.readData('ACCESS_TOKEN');

    final params = type != 'top10'
        ? {
            'address':
                '$region $area', // '${authState.user?.region?.split('-')[2]} ${authState.user?.region?.split('-')[3]}'
          }
        : null;

    final url = Uri.http('3.107.105.153:5001', '/youth-policy/$type', params);
    final response = await http.get(
      url,
      headers: {'accept': 'application/json'},
    ); //await rootBundle.loadString('assets/dummy/dummy_policy_list_gangnam.json',);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      /**
       * final List<dynamic> policyListJson = decodedJson["policies"];
      final List<PolicyModel> policies = policyListJson
          .map((jsonItem) => PolicyModel.fromJson(jsonItem))
          .toList();
       */
      return decodedJson['policies'];
    } else {
      throw Exception('Failed to load policy list');
    }
  }

  Future<List<dynamic>> fetchPolicyDummy(
    String type,
    String? region,
    String? area,
  ) async {
    final response = await rootBundle.loadString(
      'assets/dummy/dummy_policy_list_gangnam.json',
    );

    if (response.isNotEmpty) {
      final Map<String, dynamic> decodedJson = json.decode(response);
      /**
       * final List<dynamic> policyListJson = decodedJson["policies"];
      final List<PolicyModel> policies = policyListJson
          .map((jsonItem) => PolicyModel.fromJson(jsonItem))
          .toList();
       */
      return decodedJson['policies'];
    } else {
      throw Exception('Failed to load policy list');
    }
  }

  // productType은 savings, deposits, search
  Future<List<dynamic>> fetchProduct(
    String productType,
    String? keyword,
  ) async {
    final token = SecureStorageManager.readData('ACCESS_TOKEN');
    final params = keyword != null ? {"keyword": keyword} : null;
    final url = Uri.http(
      '16.176.134.222:8080',
      '/api/v1/financial/$productType',
      params,
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'accept': '*/*'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);

      return productType != 'search'
          ? decodedJson['data']
          : decodedJson['data']['products'];
    } else {
      print('[DEBUG:Fetch Product] ${response.statusCode}');
      throw Exception('Failed to load product($productType) list');
    }
  }

  // productType은 savings, deposits, search
  Future<List<dynamic>> fetchProductDummy(
    String productType,
    String? keyword,
  ) async {
    String jsonString = await rootBundle.loadString(
      'assets/dummy/dummy_${productType}${keyword ?? ''}_list.json',
    );

    if (jsonString.isNotEmpty) {
      final Map<String, dynamic> decodedJson = json.decode(jsonString);

      return productType != 'search'
          ? decodedJson['data']
          : decodedJson['data']['products'];
    } else {
      throw Exception('Fail to load product($productType) list');
    }
  }

  Future<List<List<dynamic>>> fetchBondProduct() async {
    final token = SecureStorageManager.readData('ACCESS_TOKEN');
    final url = Uri.http('16.176.134.222:8080', '/api/v1/financial/bond');
    final response = await http.get(
      url,
      headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final Map<String, dynamic> data = decodedJson['data'];

      return [data['sortByInterest'], data['sortByMaturity']];
    } else {
      throw Exception('Fail to load bond product list');
    }
  }

  Future<List<List<dynamic>>> fetchBondProductDummy() async {
    String jsonString = await rootBundle.loadString(
      'assets/dummy/dummy_bonds_list.json',
    );

    if (jsonString.isNotEmpty) {
      final Map<String, dynamic> decodedJson = json.decode(jsonString);
      final Map<String, dynamic> data = decodedJson['data'];

      return [data['sortByInterest'], data['sortByMaturity']];
    } else {
      throw Exception('Fail to load bond product list');
    }
  }

  Future<RecommendProductModel /*Map<String, dynamic>*/> fetchRecommendProduct({
    required int targetAmount,
    required int targetMonths,
    int? currentAmount,
    String? riskPreference,
  }) async {
    final token = await SecureStorageManager.readData('ACCESS_TOKEN');
    print(token);

    final body = {
      'targetAmount': 1000000, //targetAmount,
      'targetMonths': targetMonths,
      if (currentAmount != null) 'currentAmount': currentAmount,
      if (riskPreference != null) 'riskPreference': riskPreference,
    };

    final url = Uri.http('16.176.134.222:8080', '/api/v1/financial/recommend');
    print(jsonEncode(body));

    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print(response.statusCode);
    //print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);

      if (decodedJson.isEmpty || decodedJson['success'] != true) {
        throw Exception('Failed to load recommendation product list');
      }
      final RecommendProductModel selectedJson = RecommendProductModel.fromJson(
        decodedJson['data']['optimalCombination'],
      );

      //print("[DEBUG] ${decodedJson}");
      print("[DEBUG] ${selectedJson.products?.first.productName}");
      return selectedJson;
    } else {
      throw Exception('Failed to load recommendation product list');
    }
  }

  Future<RecommendProductModel> fetchRecommendProductDummy({
    required int targetAmount,
    required int targetMonths,
    int? currentAmount,
    int? riskPreference,
  }) async {
    String jsonString = await rootBundle.loadString(
      'assets/dummy/dummy_recommend_product_list.json',
    );

    final Map<String, dynamic> decodedJson = json.decode(jsonString);
    if (decodedJson.isNotEmpty || decodedJson['success'] == true) {
      final RecommendProductModel selectedJson = RecommendProductModel.fromJson(
        decodedJson['data']['optimalCombination'],
      );

      //print("[DEBUG] ${decodedJson}");
      //print("[DEBUG] ${selectedJson.products?.first.productName}");
      return selectedJson;
    } else {
      throw Exception('Failed to load recommendation product list');
    }
  }

  Future<List<List<dynamic>>> fetchEtfProduct() async {
    final token = SecureStorageManager.readData('ACCESS_TOKEN');
    final url = Uri.http('16.176.134.222:8080', '/api/etf');
    final response = await http.get(
      url,
      headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final Map<String, dynamic> data = decodedJson['data'];

      return data['etfs'];
    } else {
      throw Exception('Fail to load etf product list');
    }
  }

  Future<Map<String, dynamic>> postSurveyResult({
    required int investmentMethod,
    required int lossTolerance,
    required List<bool> preferredInvestmentTypes,
    required int investmentPeriod,
    required String investmentGoal,
    required int targetAmount,
  }) async {
    final token = SecureStorageManager.readData('ACCESS_TOKEN');

    List<String> trueIndices = preferredInvestmentTypes
        .asMap() // {0: true, 1: false, 2: true, 3: true}
        .entries // [(0, true), (1, false), (2, true), (3, true)]
        .where(
          (entry) => entry.value == true,
        ) // [(0, true), (2, true), (3, true)]
        .map((entry) => preferredInvestmentTypeKeys[entry.key]) // [0, 2, 3]
        .toList();

    final body = {
      "investmentMethod": investmentMethodKeys[investmentMethod],
      "lossTolerance": lossToleranceKeys[lossTolerance],
      "preferredInvestmentTypes": trueIndices,
      "investmentPeriod": investmentPeriod,
      "investmentGoal": investmentGoal,
      "targetAmount": targetAmount,
      "address": "string",
    };

    final url = Uri.http('16.176.134.222:8080', '/api/financial/recoommend');
    final response = await http.post(
      url,
      body: body,
      headers: {'Authorization': 'Bearer ${token}', 'accept': '*/*'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);

      return decodedJson['analysis'];
    } else {
      throw Exception('Failed to post survey result');
    }
  }

  Future<Map<String, dynamic>> fetchPreference() async {
    final url = Uri.http('16.176.134.222:8080', '/api/v1/onboard/preference');
    final token = await SecureStorageManager.readData('ACCESS_TOKEN');

    final header = {'accept': '*/*', 'Authorization': 'Bearer ${token!}'};
    final response = await http.get(url, headers: header);

    print('[DEBUG:fetchPrefernce] ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);

      return {
        "completed": decodedJson["completed"],
        "riskLevel": decodedJson["riskLevel"],
        "investmentPeriod": decodedJson["investmentPeriod"] != 0
            ? decodedJson["investmentPeriod"]
            : null,
        "preferredInvestmentTypes": decodedJson["preferredInvestmentTypes"],
        "targetAmount": decodedJson["targetAmount"] != 0
            ? decodedJson["targetAmount"]
            : null,
        "investmentGoal": decodedJson["investmentGoal"],
        "lossTolerance": decodedJson["lossTolerance"],
        "investmentMethod": decodedJson["investmentMethod"],
      };
    } else {
      print('[DEBUG:fetchPrefernce] ${response.statusCode}');
      throw Exception('성향 조회 실패');
    }
  }
}
