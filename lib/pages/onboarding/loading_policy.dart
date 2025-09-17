import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class LoadingPolicyPage extends StatefulHookConsumerWidget {
  const LoadingPolicyPage({super.key});

  @override
  ConsumerState<LoadingPolicyPage> createState() => _LoadingPolicyPageState();
}

class _LoadingPolicyPageState extends ConsumerState<LoadingPolicyPage> {
  Future loading() async {
    // 투자 성향 분석 로딩 대체 timer
    Timer(Duration(milliseconds: 3000), () {
      GoRouter.of(context).go('/post_test_result');
    });

    //정책 검색 완료 후 완료 신호 받으면 다음 페이지
  }

  @override
  void initState() {
    super.initState();

    loading();
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
                  TextSpan(text: ' 님에게 \n딱 맞는 정책을 검색중입니다'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
