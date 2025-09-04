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

class PostTestResultPage extends StatefulHookConsumerWidget {
  const PostTestResultPage({super.key});

  @override
  ConsumerState<PostTestResultPage> createState() => _PostTestResultPageState();
}

class _PostTestResultPageState extends ConsumerState<PostTestResultPage> {
  Future loading() async {
    // 투자 성향 분석 로딩 대체 timer
    Timer(Duration(milliseconds: 1000), () {
      GoRouter.of(context).go('/signIn');
    });
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
