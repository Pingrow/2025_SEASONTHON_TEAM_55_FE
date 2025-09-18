class ETFModel {
  final String srtnCd;
  final String itmsNm;
  final String corpNm;
  final int clpr; // Dart의 int는 64비트 정수이므로 Long을 대체합니다.
  final String vs;
  final String fltRt;
  final int trqu;
  final int mrktTotAmt;

  // 생성자
  ETFModel({
    required this.srtnCd,
    required this.itmsNm,
    required this.corpNm,
    required this.clpr,
    required this.vs,
    required this.fltRt,
    required this.trqu,
    required this.mrktTotAmt,
  });

  // Map(JSON)으로부터 ETFModel 객체를 생성하는 팩토리 생성자
  factory ETFModel.fromJson(Map<String, dynamic> json) {
    return ETFModel(
      srtnCd: json['srtnCd'] as String,
      itmsNm: json['itmsNm'] as String,
      corpNm: json['corpNm'] as String,
      clpr: json['clpr'] as int,
      vs: json['vs'] as String,
      fltRt: json['fltRt'] as String,
      trqu: json['trqu'] as int,
      mrktTotAmt: json['mrktTotAmt'] as int,
    );
  }

  // ETFModel 객체를 Map(JSON)으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'srtnCd': srtnCd,
      'itmsNm': itmsNm,
      'corpNm': corpNm,
      'clpr': clpr,
      'vs': vs,
      'fltRt': fltRt,
      'trqu': trqu,
      'mrktTotAmt': mrktTotAmt,
    };
  }
}
