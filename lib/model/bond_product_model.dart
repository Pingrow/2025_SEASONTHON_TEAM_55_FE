class BondProductModel {
  final String? bondIsurNm;
  final String? isinCdNm;
  final double? bondSrfcInrt;
  final String? bondExprDt;

  BondProductModel({
    required this.bondIsurNm,
    required this.isinCdNm,
    required this.bondSrfcInrt,
    required this.bondExprDt,
  });

  factory BondProductModel.fromJson(Map<String, dynamic> json) {
    return BondProductModel(
      bondIsurNm: json['bondIsurNm'],
      isinCdNm: json['isinCdNm'],
      bondSrfcInrt: json['bondSrfcInrt'],
      bondExprDt: json['bondExprDt'],
    );
  }
}
