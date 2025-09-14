import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:linear_progress_bar/ui/dots_indicator.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/pages/onboarding/research_page_step5.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/auth_state.dart';
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
              child: Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Color(0x70999999)),
                ),
              ),
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
                      await authViewModel.kakaoLogin().then((value) async {
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
