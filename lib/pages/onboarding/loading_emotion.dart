import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class LoadingEmotionPage extends StatefulHookConsumerWidget {
  const LoadingEmotionPage({super.key});

  @override
  ConsumerState<LoadingEmotionPage> createState() => _LoadingEmotionPageState();
}

class _LoadingEmotionPageState extends ConsumerState<LoadingEmotionPage> {
  Future loading() async {
    // 투자 성향 분석 로딩 대체 timer
    Timer(Duration(milliseconds: 1000), () {
      GoRouter.of(context).go('/lodaing_policy');
    });
  }

  @override
  void initState() {
    super.initState();

    //loading();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authViewModelProvider).user;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 180.h, 0, 0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xfffcf7ec),
                ),
                children: [
                  TextSpan(
                    text: user?.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' 님의 \n성향을 분석중입니다'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
