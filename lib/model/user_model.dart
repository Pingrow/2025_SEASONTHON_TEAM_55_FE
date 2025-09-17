import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum RiskLevel { unknown, conservative, cautious, balanced, growth, aggresive }

class UserModel {
  final int? id;
  final String? nickname;
  final String? email;
  final String? profile_url;
  final RiskLevel? type;
  final String? goal;
  final int? goal_money;
  final int? goal_period;
  final bool? research_completed;
  final int? saved_money;
  final String? region;

  UserModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.profile_url,
    this.type = RiskLevel.unknown,
    this.goal = '',
    this.goal_money,
    this.goal_period,
    this.saved_money,
    this.research_completed = false,
    this.region = '17-0-NODATA-???',
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
      type: RiskLevel.values.byName(
        user['type'] != "null" ? user['type'] ?? 'unknown' : 'unknown',
      ),
      goal: user['goal'],
      goal_money: user['goal_money'],
      goal_period: user['goal_period'],
      saved_money: user['saved_money'],
      research_completed: user['research_completed'],
      region: user['region'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'profile_url': profile_url,
      'type': type?.name,
      'goal': goal,
      'goal_money': goal_money,
      'goal_period': goal_period,
      'saved_money': saved_money,
      'research_completed': research_completed,
      'region': region,
    };
  }
}
