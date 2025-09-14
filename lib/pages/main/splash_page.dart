import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/providers/region_provider.dart';
//import 'package:pin_grow/repository/auth_repository.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class SplashPage extends StatefulHookConsumerWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Future loading() async {
    /**
     * // 기본 로딩 작업 대체 timer
    Timer(Duration(milliseconds: 1000), () {
      GoRouter.of(context).go('/signIn');
    });
     */
    /** TEST CODE
     * SecureStorageManager.saveData(
      'AUTH_STATE',
      jsonEncode(
        AuthState(
          status: AuthStatus.authenticated,
          user: UserModel(
            id: 101010101,
            nickname: '핀그로우',
            email: 'pingrow@example.com',
            profile_url: 'http://profile.example.com',
          ),
        ),
      ).toString(),
    );

     */

    // Debugging 용 데이터 삭제 + 로그아웃 코드
    //SecureStorageManager.deleteAllData();
    await ref.read(authViewModelProvider.notifier).logout();

    /**
     * AuthState? authState = AuthState.fromRawJson(
      (await SecureStorageManager.readData('AUTH_STATE')),
    );

    print('[DEBUG #1] : ${authState.toJson()}');
     */

    await ref.read(regionProvider.notifier).getRegions();

    try {
      AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
      print(
        '액세스 토큰 정보 조회 성공'
        '\n회원정보: ${tokenInfo.id}'
        '\n만료시간: ${tokenInfo.expiresIn} 초',
      );
    } catch (error) {
      print('액세스 토큰 정보 조회 실패 $error');
    }

    AuthState? authState = await ref
        .read(authViewModelProvider.notifier)
        .getUserFromSecureStorage();

    print('[DEBUG:SPLASH] ${authState?.toJson()}');

    //print('${authState.user} ${authState.status}');

    /**
    

    ref
        .read(authViewModelProvider.notifier)
        .setAuthState(authState.status, authState.user);
 */
    switch (authState?.status ?? AuthStatus.unauthenticated) {
      case AuthStatus.unauthenticated || AuthStatus.error:
        //GoRouter.of(context).go('/product_list');
        GoRouter.of(context).go('/home');
        break;
      case AuthStatus.loading:
        break;
      case AuthStatus.authenticated:
        // 설문 완료 확인 : (완료) -> home으로, (미완료) -> 설문페이지(step1)로
        // 현재는 백엔드 서버랑 연결되어 있지 않아 secure storage에 저장된 정보를 사용해서 완료 확인 -> 데이터를 지우면 새로운 사람!
        bool? researchComplete = authState?.user?.research_completed;

        print(researchComplete);
        if (researchComplete ?? false) {
          //GoRouter.of(context).go('/post_test_result');
          //GoRouter.of(context).go('/policy_list');
          GoRouter.of(context).go('/home');
        } else {
          GoRouter.of(context).go('/step1');
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    loading();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0fa564), Color(0xff3cba92)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 260,
            height: 108,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/logo/logo-text.svg',
                      width: 197,
                      height: 72,
                    ),
                    Image.asset(
                      'assets/logo/logo-pin.png',
                      width: 51,
                      height: 51,
                    ),
                  ],
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xfffcf7ec),
                    ),
                    children: [
                      TextSpan(text: '당신의 미래를 키우는 작은 씨앗, '),
                      TextSpan(
                        text: '핀그로우',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
