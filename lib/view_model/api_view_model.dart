import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/model/bond_product_model.dart';
import 'package:pin_grow/model/data_lists.dart';
import 'package:pin_grow/model/etf_model.dart';
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
    final List<dynamic> productListJson = //await _repository.fetchProductDummy(
    await _repository.fetchProduct(
      'deposits',
      null,
    );
    final List<ProductModel> products = productListJson
        .map((jsonItem) => ProductModel.fromJson(jsonItem))
        .toList();

    return products;
  }

  Future<List<ProductModel>> fetchSavingsList() async {
    final List<dynamic> productListJson = //await _repository.fetchProductDummy(
    await _repository.fetchProduct(
      'savings',
      null,
    );

    final List<ProductModel> products = productListJson
        .map((jsonItem) => ProductModel.fromJson(jsonItem))
        .toList();

    return products;
  }

  Future<List<ProductModel>> fetchSearchList(String? keyword) async {
    final List<dynamic> productListJson = //await _repository.fetchProductDummy(
    await _repository.fetchProduct(
      'search',
      keyword,
    );
    final List<ProductModel> products = productListJson
        .map((jsonItem) => ProductModel.fromJson(jsonItem))
        .toList();

    return products;
  }

  Future<(List<BondProductModel>, List<BondProductModel>)>
  fetchBondsList() async {
    final List<List<dynamic>> productListJson = await _repository
        .fetchBondProductDummy(
          //await _repository.fetchBondProduct(
        );
    final List<BondProductModel> sortByInterest = productListJson[0]
        .map((jsonItem) => BondProductModel.fromJson(jsonItem))
        .toList();

    final List<BondProductModel> sortByMaturity = productListJson[1]
        .map((jsonItem) => BondProductModel.fromJson(jsonItem))
        .toList();

    return (sortByInterest, sortByMaturity);
  }

  Future<List<OptimalProductModel>> fetchRecommendation(UserModel user) async {
    final RecommendProductModel recommendProductModel = await _repository
        //.fetchRecommendProductDummy(
        .fetchRecommendProduct(
          targetAmount: user.goal_money!,
          targetMonths: user.goal_period!,
          currentAmount: user.saved_money ?? 0,
          riskPreference:
              riskLevelKeys[RiskLevel.values.indexOf(user.type!) - 1],
        );
    final List<OptimalProductModel> products = recommendProductModel.products!;

    print(products.first.depositAmount);

    return products;
  }
}

@Riverpod(keepAlive: true)
class PolicyViewModel extends _$PolicyViewModel {
  late final ApiRepository _repository = ref.watch(apiRepositoryProvider);

  @override
  PolicyModel build() {
    return PolicyModel(plcyNm: '', sprvsnInstCdNm: '', inqCnt: null, url: '');
  }

  Future<List<PolicyModel>> fetchPolicyList() async {
    final authState = ref.read(authViewModelProvider);

    final region = authState.user?.region?.split('-')[2] ?? 'NODATA';
    final area = authState.user?.region?.split('-')[3] ?? '???';

    print('$region $area');

    final List<dynamic> policyListJson = //await _repository.fetchPolicyDummy(
    await _repository.fetchPolicy(
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

    final List<dynamic> policyListJson = //await _repository.fetchPolicyDummy(
    await _repository.fetchPolicy(
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

@Riverpod(keepAlive: true)
class SurveyViewModel extends _$SurveyViewModel {
  late final ApiRepository _repository = ref.watch(apiRepositoryProvider);

  @override
  int build() {
    return 0;
  }

  Future<bool> checkCompleted() async {
    final data = await _repository.fetchPreference();
    return data['compeleted'];
  }

  Future<RiskLevel> getRiskLevel() async {
    final data = await _repository.fetchPreference();
    return RiskLevel.values[riskLevelKeys.indexOf(data['riskLevel'])];
  }

  Future<bool> completeSurvey({
    required final investmentMethod,
    required final lossTolerance,
    required final preferredInvestmentTypes,
    required final investmentPeriod,
    required final investmentGoal,
    required final targetAmount,
  }) async {
    final data = await _repository.postSurveyResult(
      investmentMethod: investmentMethod,
      lossTolerance: lossTolerance,
      preferredInvestmentTypes: preferredInvestmentTypes,
      investmentPeriod: investmentPeriod,
      investmentGoal: investmentGoal,
      targetAmount: targetAmount,
    );

    return data['riskProfile'] != null;
  }
}

@Riverpod(keepAlive: true)
class EtfViewModel extends _$EtfViewModel {
  late final ApiRepository _repository = ref.watch(apiRepositoryProvider);

  @override
  List<EtfViewModel> build() {
    return [];
  }

  Future<List<ETFModel>> fetchEtfList() async {
    final List<dynamic> data = await _repository.fetchEtfProduct();
    final List<ETFModel> etfs = data
        .map((jsonItem) => ETFModel.fromJson(jsonItem))
        .toList();

    return etfs;
  }
}
