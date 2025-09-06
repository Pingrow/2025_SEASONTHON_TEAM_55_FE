class PolicyModel {
  final String? plcyNm;
  final String? sprvsnInstCdNm;
  final int? incCnt;
  final String? url;

  PolicyModel({
    required this.plcyNm,
    required this.sprvsnInstCdNm,
    required this.incCnt,
    required this.url,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      plcyNm: json['plcyNm'],
      sprvsnInstCdNm: json['sprvsnInstCdNm'],
      incCnt: json['incCnt'],
      url: json['url'],
    );
  }
}
