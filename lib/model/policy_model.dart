class PolicyModel {
  final String? plcyNm;
  final String? sprvsnInstCdNm;
  final int? inqCnt;
  final String? url;

  PolicyModel({
    required this.plcyNm,
    required this.sprvsnInstCdNm,
    required this.inqCnt,
    required this.url,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      plcyNm: json['plcyNm'],
      sprvsnInstCdNm: json['sprvsnInstCdNm'],
      inqCnt: json['inqCnt'],
      url: json['url'],
    );
  }
}
