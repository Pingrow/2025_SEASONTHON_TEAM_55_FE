import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/model/policy_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../view_model/auth_view_model.dart';

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
    OAuthToken? token = await TokenManagerProvider.instance.manager.getToken();

    final params = type != 'top10'
        ? {
            'address':
                '$region $area', // '${authState.user?.region?.split('-')[2]} ${authState.user?.region?.split('-')[3]}'
          }
        : null;

    final url = Uri.http('16.176.49.213:5001', '/youth-policy/$type', params);
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

  // productType은 saving, deposit
  Future<List<dynamic>> fetchProduct(
    String productType,
    String? keyword,
  ) async {
    OAuthToken? token = await TokenManagerProvider.instance.manager.getToken();
    final params = keyword != null ? {"keyword": keyword} : null;
    final url = Uri.http(
      '3.27.44.246:8080',
      '/api/financial/$productType',
      params,
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${token!.accessToken}',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);

      return decodedJson['data'];
    } else {
      throw Exception('Failed to load product($productType) list');
    }
  }

  Future<Map<String, dynamic>> fetchRecommendProduct({
    required int targetAmount,
    required int targetMonths,
    int? currentAmount,
    int? riskPreference,
  }) async {
    OAuthToken? token = await TokenManagerProvider.instance.manager.getToken();
    //final String riskPreferenceList =

    final body = {
      "targetAmount": targetAmount,
      "targetMonths": targetMonths,
      "currentAmount": currentAmount,
      "riskPreference": riskPreference,
    };
    final url = Uri.http('3.27.44.246:8080', '/api/financial/recoommend');
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Authorization': 'Bearer ${token!.accessToken}',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final Map<String, dynamic> selectedJson = {
        'combinationSummary': decodedJson['combinationSummary'],
        'totalExpectedReturn': decodedJson['totalExpectedReturn'],
        'expectedTotalAmount': decodedJson['expectedTotalAmount'],
        'riskLevel': decodedJson['riskLevel'],
        'description': decodedJson['description'],
        'products': decodedJson['products'],
      };
      return selectedJson;
    } else {
      throw Exception('Failed to load recommendation product list');
    }
  }
}
