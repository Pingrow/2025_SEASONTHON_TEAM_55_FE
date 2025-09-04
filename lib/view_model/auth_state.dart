import 'dart:convert';

import 'package:pin_grow/model/user_model.dart';

enum AuthStatus { unauthenticated, authenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name, // enum은 .name으로 문자열로 변환하는 것이 안전합니다.
      'user': user?.toJson(), // UserModel도 toJson을 호출해야 합니다.
      'errorMessage': errorMessage,
    };
  }

  /// Map(JSON) 형태에서 AuthState 객체를 생성합니다.
  factory AuthState.fromJson(Map<String, dynamic> json) {
    return AuthState(
      status: AuthStatus.values.byName(json['status'] ?? 'unauthenticated'),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      errorMessage: json['errorMessage'],
    );
  }

  /// AuthState 객체를 JSON 문자열로 직접 변환합니다.
  String? toRawJson() => jsonEncode(toJson());

  /// JSON 문자열에서 AuthState 객체를 직접 생성합니다.
  factory AuthState.fromRawJson(String? source) {
    if (source != null) {
      return AuthState.fromJson(jsonDecode(source));
    }

    return AuthState();
  }
}
