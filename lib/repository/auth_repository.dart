import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

class AuthRepository {
  Future<void> loginWithKakao() async {
    if (
    /**false && */
    await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (e) {
        print('카카오 로그인 실패 $e');

        if (e is PlatformException && e.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오 계정으로 로그인 성공 ${token.accessToken}');
      } catch (e) {
        print('카카오 계정으로 로그인 실패 $e');

        if (e is PlatformException && e.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    }
  }

  Future<void> login() async {
    OAuthToken? token = await TokenManagerProvider.instance.manager.getToken();

    if (token == null) {
      throw Exception('카카오 토큰 없음');
    }

    final url = Uri.http('52.64.10.16:8080', '/api/v1/auth/kakao');
    print("[DEBUG] KAKAO Access Token : ${token!.accessToken}");
    final body = {'code': token.accessToken};
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);

      SecureStorageManager.saveData(
        'ACCESS_TOKEN',
        decodedJson['access_token'],
      );
    } else {
      throw Exception('로그인 실패');
    }
  }

  Future<void> kakaoLogout() async {
    try {
      await UserApi.instance.logout();
    } catch (e) {
      print('로그아웃 실패, 토큰 만료 등 $e');
    }
  }

  Future<void> logout() async {
    try {
      /// TODO: 로그아웃 api있는지
      SecureStorageManager.deleteAllData();
    } catch (e) {
      print('로그아웃 실패, 토큰 만료 등 $e');
    }
  }
}
