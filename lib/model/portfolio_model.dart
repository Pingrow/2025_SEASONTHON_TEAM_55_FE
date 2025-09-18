import 'dart:convert';

// 최상위 데이터 구조
class PortfolioModel {
  final String riskLevel;
  final int targetAmount;
  final int investmentPeriod;
  final PortfolioAllocation allocation;
  final num expectedTotal;
  final PortfolioRecommendedProducts recommendedProducts;
  final String gptReasoning;

  PortfolioModel({
    required this.riskLevel,
    required this.targetAmount,
    required this.investmentPeriod,
    required this.allocation,
    required this.expectedTotal,
    required this.recommendedProducts,
    required this.gptReasoning,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      riskLevel: json['riskLevel'],
      targetAmount: json['targetAmount'],
      investmentPeriod: json['investmentPeriod'],
      allocation: PortfolioAllocation.fromJson(json['allocation']),
      expectedTotal: json['expectedTotal'],
      recommendedProducts: PortfolioRecommendedProducts.fromJson(
        json['recommendedProducts'],
      ),
      gptReasoning: json['gptReasoning'],
    );
  }
}

// "allocation" 객체
class PortfolioAllocation {
  // additionalProp1, 2, 3 등을 동적으로 처리하기 위해 Map 사용
  final Map<String, num> properties;

  PortfolioAllocation({required this.properties});

  factory PortfolioAllocation.fromJson(Map<String, dynamic> json) {
    // json의 모든 키-값 쌍을 새로운 Map으로 변환
    return PortfolioAllocation(properties: Map<String, num>.from(json));
  }
}

// "recommendedProducts" 객체
class PortfolioRecommendedProducts {
  // additionalProp1, 2, 3 등을 동적으로 처리하기 위해 Map 사용
  // 각 키의 값은 Product 객체의 리스트
  final Map<String, List<PortfolioProduct>> products;

  PortfolioRecommendedProducts({required this.products});

  factory PortfolioRecommendedProducts.fromJson(Map<String, dynamic> json) {
    final Map<String, List<PortfolioProduct>> tempProducts = {};
    json.forEach((key, value) {
      // value는 List<dynamic> 타입이므로, 각 항목을 Product.fromJson으로 변환
      var productList = (value as List)
          .map((item) => PortfolioProduct.fromJson(item))
          .toList();
      tempProducts[key] = productList;
    });

    return PortfolioRecommendedProducts(products: tempProducts);
  }
}

// 개별 추천 상품 객체
class PortfolioProduct {
  final String name;
  final String bank;
  final num rate; // int일 수도 double일 수도 있으므로 num 타입 사용
  final String term;
  final num investAmount;
  final num expectedValue;

  PortfolioProduct({
    required this.name,
    required this.bank,
    required this.rate,
    required this.term,
    required this.investAmount,
    required this.expectedValue,
  });

  factory PortfolioProduct.fromJson(Map<String, dynamic> json) {
    return PortfolioProduct(
      name: json['name'],
      bank: json['bank'],
      rate: json['rate'],
      term: json['term'],
      investAmount: json['investAmount'],
      expectedValue: json['expectedValue'],
    );
  }
}
