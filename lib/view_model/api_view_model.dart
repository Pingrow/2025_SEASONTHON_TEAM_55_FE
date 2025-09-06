import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/model/policy_model.dart';
import 'package:pin_grow/model/product_model.dart';
import 'package:pin_grow/model/recommend_product_model.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/repository/api_repository.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pin_grow/repository/auth_repository.dart';
import 'package:pin_grow/view_model/auth_state.dart';

part 'api_view_model.g.dart';

@Riverpod(keepAlive: true)
class ProductViewModel extends _$ProductViewModel {
  late final ApiRepository _repository = ref.watch(apiRepositoryProvider);

  @override
  ProductModel build() {
    return ProductModel(
      id: null,
      bankName: '',
      productName: '',
      productType: '',
      bestRate: null,
      bestTerm: null,
    );
  }

  Future<List<ProductModel>> fetchDepositList() async {
    final List<dynamic> productListJson = await _repository.fetchProduct(
      'deposit',
      null,
    );
    final List<ProductModel> products = productListJson
        .map((jsonItem) => ProductModel.fromJson(jsonItem))
        .toList();

    return products;
  }

  Future<List<ProductModel>> fetchSavingsList() async {
    final List<dynamic> productListJson = await _repository.fetchProduct(
      'savings',
      null,
    );
    final List<ProductModel> products = productListJson
        .map((jsonItem) => ProductModel.fromJson(jsonItem))
        .toList();

    return products;
  }

  Future<List<ProductModel>> fetcSearchList(String keyword) async {
    final List<dynamic> productListJson = await _repository.fetchProduct(
      'search',
      keyword,
    );
    final List<ProductModel> products = productListJson
        .map((jsonItem) => ProductModel.fromJson(jsonItem))
        .toList();

    return products;
  }

  Future<RecommendProductModel> fetchRecommendation(UserModel user) async {
    final Map<String, dynamic> productMapJson = await _repository
        .fetchRecommendProduct(
          targetAmount: user.goal_money!,
          targetMonths: user.goal_period!,
        );
    final RecommendProductModel products = RecommendProductModel.fromJson(
      productMapJson,
    );

    return products;
  }
}

@Riverpod(keepAlive: true)
class PolicyViewModel extends _$PolicyViewModel {
  late final ApiRepository _repository = ref.watch(apiRepositoryProvider);

  @override
  PolicyModel build() {
    return PolicyModel(plcyNm: '', sprvsnInstCdNm: '', incCnt: null, url: '');
  }

  Future<List<PolicyModel>> fetchPolicyList() async {
    final authState = ref.read(authViewModelProvider);

    final region = authState.user?.region?.split('-')[2] ?? 'NODATA';
    final area = authState.user?.region?.split('-')[3] ?? '???';

    print('$region $area');

    final List<dynamic> policyListJson = await _repository.fetchPolicy(
      'policies',
      region,
      area,
    );
    final List<PolicyModel> policies = policyListJson
        .map((jsonItem) => PolicyModel.fromJson(jsonItem))
        .toList();

    return policies;
  }

  Future<List<PolicyModel>> fetchTop10PolicyList() async {
    final authState = ref.read(authViewModelProvider);

    final region = authState.user?.region?.split('-')[2] ?? 'NODATA';
    final area = authState.user?.region?.split('-')[3] ?? '???';

    final List<dynamic> policyListJson = await _repository.fetchPolicy(
      'top10',
      region,
      area,
    );
    final List<PolicyModel> policies = policyListJson
        .map((jsonItem) => PolicyModel.fromJson(jsonItem))
        .toList();

    return policies;
  }
}
