/// TODO:
/// User 데이터 구조 확인하고 다시 작성
class UserModel {
  final int? id;
  final String? nickname;
  final String? email;
  final String? profile_url;

  UserModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.profile_url,
  });

  factory UserModel.fromKakao(Map<String, dynamic> user) {
    return UserModel(
      id: user['id'],
      nickname: user['kakaoAccount']['profile']['nickname'],
      email: user['kakaoAccount']['email'],
      profile_url: user['kakaoAccount']['profile']['profile_url'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> user) {
    return UserModel(
      id: user['id'],
      nickname: user['nickname'],
      email: user['email'],
      profile_url: user['profile_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'profile_url': profile_url,
    };
  }
}
