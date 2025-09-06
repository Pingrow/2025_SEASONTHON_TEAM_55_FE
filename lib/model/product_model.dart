class ProductModel {
  final int? id;
  final String? bankName;
  final String? productName;
  final String? productType;
  final double? bestRate;
  final int? bestTerm;

  ProductModel({
    required this.id,
    required this.bankName,
    required this.productName,
    required this.productType,
    required this.bestRate,
    required this.bestTerm,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json['id']),
      bankName: json['bankName'],
      productName: json['productName'],
      productType: json['productType'],
      bestRate: double.parse(json['bestRate']),
      bestTerm: int.parse(json['bestTerm']),
    );
  }
}
