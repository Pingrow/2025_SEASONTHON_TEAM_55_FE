import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class SignInPage extends StatefulHookConsumerWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);

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

          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () async {
                if (authState.status == AuthStatus.unauthenticated ||
                    authState.status == AuthStatus.error) {
                  await authViewModel.kakaoLogin().then((value) async {
                    await authViewModel.getUser();

                    SecureStorageManager.saveData(
                      'AUTH_STATE',
                      authState.toRawJson().toString(),
                    );

                    print(
                      ref.read(authViewModelProvider).user?.nickname ?? 'null',
                    );

                    /**
                     * try {
                      AccessTokenInfo tokenInfo = await UserApi.instance
                          .accessTokenInfo();
                      print(
                        '액세스 토큰 정보 조회 성공'
                        '\n회원정보: ${tokenInfo.id}'
                        '\n만료시간: ${tokenInfo.expiresIn} 초',
                      );
                    } catch (error) {
                      print('액세스 토큰 정보 조회 실패 $error');
                    }
                     */

                    if (await AuthApi.instance.hasToken()) {
                      if (true
                      /** 설문 조사했는지 조사*/
                      ) {
                        ref.read(selectedIndexProvider.notifier).setIndex(1);
                        ref
                            .read(researchResultStep1Provider.notifier)
                            .setIndex(-1);

                        GoRouter.of(
                          context,
                        ).go('/step1'); //이 부분 path 변경으로 로그인 이후 어띠로 갈지 정하게 됨
                      }
                    } else {
                      print('토큰 없음');
                    }
                  });
                }
              },
              child: Container(
                width: 347,
                height: 52,
                margin: EdgeInsets.fromLTRB(
                  0,
                  0,
                  0,
                  MediaQuery.of(context).size.height / 10,
                ),
                child: Image.asset(
                  'assets/kakao_login/ko/kakao_login_medium_wide.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
