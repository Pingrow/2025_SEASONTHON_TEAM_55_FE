class RegionModel {
  final String alias;
  final String logo;
  final List<String> areas;

  RegionModel({required this.alias, required this.logo, required this.areas});

  // JSON Map 데이터를 받아서 RegionModel 객체로 변환하는 팩토리 생성자
  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      alias: json['ALIAS'] as String,
      logo: json['LOGO'] as String,
      // json['AREAS']는 List<dynamic>이므로 List<String>으로 변환해줍니다.
      areas: List<String>.from(json['AREAS']),
    );
  }
}
