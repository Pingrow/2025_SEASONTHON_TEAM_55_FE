class OptimalProductModel {
  final String? productType;
  final String? bankName;
  final String? productName;
  final int? term;
  final double? interestRate;
  final String? specialCondition;
  final int? depositAmount;
  final int? maturityAmount;
  final int? monthlyAmount;
  final int? totalSavingAmount;
  final int? savingMaturityAmount;
  final double? expectedReturn;

  OptimalProductModel({
    required this.productType,
    required this.bankName,
    required this.productName,
    required this.term,
    required this.interestRate,
    required this.specialCondition,
    required this.depositAmount,
    required this.maturityAmount,
    required this.monthlyAmount,
    required this.totalSavingAmount,
    required this.savingMaturityAmount,
    required this.expectedReturn,
  });

  factory OptimalProductModel.fromJson(Map<String, dynamic> json) {
    return OptimalProductModel(
      productType: json['productType'],
      bankName: json['bankName'],
      productName: json['productName'],
      term: int.parse(json['term']),
      interestRate: double.parse(json['interestRate']),
      specialCondition: json['specialCondition'],
      depositAmount: int.parse(json['depositAmount']),
      maturityAmount: int.parse(json['maturityAmount']),
      monthlyAmount: int.parse(json['monthlyAmount']),
      totalSavingAmount: int.parse(json['totalSavingAmount']),
      savingMaturityAmount: int.parse(json['savingMaturityAmount']),
      expectedReturn: double.parse(json['expectedReturn']),
    );
  }
}

class RecommendProductModel {
  final String? combinationSummary;
  final double? totalExpectedReturn;
  final double? expectedTotalAmount;
  final String? riskLevel;
  final String? description;
  final List<OptimalProductModel>? products;

  RecommendProductModel({
    required this.combinationSummary,
    required this.totalExpectedReturn,
    required this.expectedTotalAmount,
    required this.riskLevel,
    required this.description,
    required this.products,
  });

  factory RecommendProductModel.fromJson(Map<String, dynamic> json) {
    return RecommendProductModel(
      combinationSummary: json['combinationSummary'] as String?,

      // JSON의 숫자 값(int 또는 double)을 안전하게 double? 타입으로 변환합니다.
      totalExpectedReturn: (json['totalExpectedReturn'] as num?)?.toDouble(),
      expectedTotalAmount: (json['expectedTotalAmount'] as num?)?.toDouble(),

      riskLevel: json['riskLevel'] as String?,
      description: json['description'] as String?,

      // 'products' 키가 null이 아니면, 리스트의 각 항목에 대해
      // OptimalProductModel.fromJson을 호출하여 객체 리스트를 생성합니다.
      products: json['products'] == null
          ? null
          : (json['products'] as List<dynamic>)
                .map(
                  (productJson) => OptimalProductModel.fromJson(
                    productJson as Map<String, dynamic>,
                  ),
                )
                .toList(),
    );
  }
}
