import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

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
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            Container(
              width: 350.w,
              height: 521.h,
              padding: EdgeInsets.fromLTRB(0, 34.h, 0, 34.h),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 310.w,
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '로그인',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: '하면 원하는 지역의\n'),
                          TextSpan(
                            text: '청년 정책',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: '을 볼 수 있어요'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 310.w,
                      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'assets/dummy/policy_example.png',
                        width: 255.w,
                        height: 251.h,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await authViewModel.login().then((value) async {
                        if (await AuthApi.instance.hasToken()) {
                          GoRouter.of(context).pop();
                        } else {
                          print('토큰 없음');
                        }
                      });
                    },
                    child: Container(
                      width: 310.w,
                      height: 46.h,

                      child: Image.asset(
                        'assets/kakao_login/ko/kakao_login_medium_wide.png',
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
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            Container(
              width: 350.w,
              height: 521.h,
              padding: EdgeInsets.fromLTRB(0, 34.h, 0, 34.h),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 310.w,
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '로그인',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: '하고 나를 위한\n'),
                          TextSpan(
                            text: '금융 상품',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: '을 확인하세요!'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 310.w,
                      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/dummy/product_example.png',
                        width: 255.w,
                        height: 251.h,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await authViewModel.login().then((value) async {
                        if (await AuthApi.instance.hasToken()) {
                          GoRouter.of(context).pop();
                        } else {
                          print('토큰 없음');
                        }
                      });
                    },
                    child: Container(
                      width: 310.w,
                      height: 46.h,

                      child: Image.asset(
                        'assets/kakao_login/ko/kakao_login_medium_wide.png',
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

class HomeLoinPopup extends StatefulHookConsumerWidget {
  const HomeLoinPopup({super.key});

  @override
  ConsumerState<HomeLoinPopup> createState() => _HomeLoinPopupState();
}

class _HomeLoinPopupState extends ConsumerState<HomeLoinPopup> {
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
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            Container(
              width: 350.w,
              height: 200.h,
              padding: EdgeInsets.fromLTRB(0, 34.h, 0, 34.h),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 310.w,
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '프로필',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: '을 확인하려면\n'),
                          TextSpan(
                            text: '로그인',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),
                          TextSpan(text: '이 필요합니다'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await authViewModel.login().then((value) async {
                        if (await AuthApi.instance.hasToken()) {
                          GoRouter.of(context).pop();
                          GoRouter.of(context).go('/profile');
                        } else {
                          print('토큰 없음');
                        }
                      });
                    },
                    child: Container(
                      width: 310.w,
                      height: 46.h,

                      child: Image.asset(
                        'assets/kakao_login/ko/kakao_login_medium_wide.png',
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
