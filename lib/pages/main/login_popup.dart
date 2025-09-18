import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/providers/providers.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

Future<void> moveAfterLogin(
  BuildContext context,
  WidgetRef ref, {
  required String path,
  bool goOnboarding = false,
}) async {
  final authState = ref.read(authViewModelProvider);

  if (await AuthApi.instance.hasToken() &&
      authState.status == AuthStatus.authenticated) {
    bool? researchComplete =
        (authState.user?.research_completed ?? false) && false;

    print('[DEBUG:Login] researchComplete : $researchComplete');

    if (!(researchComplete) && goOnboarding) {
      ref.invalidate(selectedIndexProvider);
      ref.invalidate(researchResultStep1Provider);
      ref.invalidate(researchResultStep2Provider);
      ref.invalidate(researchResultStep3Provider);
      ref.invalidate(researchResultStep4Provider);
      ref.invalidate(researchResultStep5Provider);
      GoRouter.of(context).go('/step1');
    } else {
      GoRouter.of(context).go('/home');

      GoRouter.of(context).push(path);
    }
  } else {
    print('[DEBUG:Login] tokenInfo\n${UserApi.instance.accessTokenInfo()}');
  }
}

class PolicyLoinPopup extends StatefulHookConsumerWidget {
  const PolicyLoinPopup({super.key});

  @override
  ConsumerState<PolicyLoinPopup> createState() => _PolicyLoinPopupState();
}

class _PolicyLoinPopupState extends ConsumerState<PolicyLoinPopup> {
  late final authState = ref.read(authViewModelProvider);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          0,
          MediaQuery.of(context).padding.bottom,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            Container(
              width: 385.w,
              height: 521.h,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 53.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Color(0xffC3C3C3),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),

                  Container(
                    width: 310.w,
                    margin: EdgeInsets.fromLTRB(0, 30.h, 0, 30.h),
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: '나만을 위한 '),
                          TextSpan(
                            text: '청년정책',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: ',\n 로그인하면 볼 수 있어요!'),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 310.w,
                          margin: EdgeInsets.fromLTRB(12.w, 0.h, 12.w, 0),
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/dummy/policy_example.png',
                            width: 273.w,
                            height: 226.h,
                          ),
                        ),

                        Container(
                          width: 310.w,

                          height: 186.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0x33ffffff), Color(0xffffffff)],
                              begin: AlignmentGeometry.topCenter,
                              end: AlignmentGeometry.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await authViewModel.login().then((value) async {
                        moveAfterLogin(
                          context,
                          ref,
                          path: '/policy_list',
                          goOnboarding: true,
                        );
                        //GoRouter.of(context).go('/policy_list');
                      });
                    },
                    child: Container(
                      width: 310.w,
                      height: 46.h,
                      margin: EdgeInsets.fromLTRB(0, 30.h, 0, 16.h),
                      child: Image.asset(
                        'assets/kakao_login/ko/kakao_login_medium_wide.png',
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pop();
                    },
                    child: Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7D7D7D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductLoinPopup extends StatefulHookConsumerWidget {
  const ProductLoinPopup({super.key});

  @override
  ConsumerState<ProductLoinPopup> createState() => _ProductLoinPopupState();
}

class _ProductLoinPopupState extends ConsumerState<ProductLoinPopup> {
  late final authState = ref.read(authViewModelProvider);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          0,
          MediaQuery.of(context).padding.bottom,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            Container(
              width: 385.w,
              height: 521.h,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 53.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Color(0xffC3C3C3),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),

                  Container(
                    width: 310.w,
                    margin: EdgeInsets.fromLTRB(0, 30.h, 0, 30.h),
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: '나만을 위한 '),
                          TextSpan(
                            text: '금융 상품',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: ',\n 로그인하면 볼 수 있어요!'),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      width: 310.w,
                      margin: EdgeInsets.fromLTRB(12.w, 0.h, 12.w, 0),
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/dummy/product_example.png',
                        width: 233.w,
                        height: 277.h,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      await authViewModel.login().then((value) async {
                        moveAfterLogin(
                          context,
                          ref,
                          path: '/product_list',
                          goOnboarding: true,
                        );
                        //GoRouter.of(context).go('/product_list');
                      });
                    },
                    child: Container(
                      width: 310.w,
                      height: 46.h,
                      margin: EdgeInsets.fromLTRB(0, 30.h, 0, 16.h),
                      child: Image.asset(
                        'assets/kakao_login/ko/kakao_login_medium_wide.png',
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pop();
                    },
                    child: Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7D7D7D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioLoginPopup extends StatefulHookConsumerWidget {
  const PortfolioLoginPopup({super.key});

  @override
  ConsumerState<PortfolioLoginPopup> createState() =>
      _PortfolioLoginPopupState();
}

class _PortfolioLoginPopupState extends ConsumerState<PortfolioLoginPopup> {
  late final authState = ref.read(authViewModelProvider);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          0,
          MediaQuery.of(context).padding.bottom,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            Container(
              width: 385.w,
              height: 521.h,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 53.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Color(0xffC3C3C3),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 24.h, 0, 24.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '안녕하세요, ',
                          style: TextStyle(
                            color: Color(0xff374151),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          'assets/logo/home_top_logo.png',
                          width: 83.w,
                          height: 30.h,
                        ),
                        Text(
                          '입니다.',
                          style: TextStyle(
                            color: Color(0xff374151),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 310.w,
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: '나만을 위한 포트폴리오,\n'),
                          TextSpan(
                            text: '로그인',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: '하고 확인하세요'),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: 310.w,
                    margin: EdgeInsets.fromLTRB(12.w, 13.h, 12.w, 24.h),
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/characters/portfolio_login.png',
                      width: 196.w,
                      height: 196.h,
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      await authViewModel.login().then((value) async {
                        moveAfterLogin(
                          context,
                          ref,
                          path: '/home',
                          goOnboarding: true,
                        );
                        //GoRouter.of(context).go('/product_list');
                      });
                    },
                    child: Container(
                      width: 310.w,
                      height: 46.h,
                      margin: EdgeInsets.fromLTRB(0, 30.h, 0, 16.h),

                      child: Image.asset(
                        'assets/kakao_login/ko/kakao_login_medium_wide.png',
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pop();
                    },
                    child: Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7D7D7D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
