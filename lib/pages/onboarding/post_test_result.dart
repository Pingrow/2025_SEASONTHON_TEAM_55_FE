import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

Map<UserType, Map<String, dynamic>> user_type_resource = {
  UserType.conservative: {
    'TYPE_NAME': '안정형',
    'IMAGE_URL': 'assets/characters/research_step_3_conservative.png',
    'COMMENT': '이 성향은 예금, 적금 수준의 수익을 기대해요.\n작은 원금 손실도 감내하기 어려운 유형입니다.',
    'PERCENT': 'N',
    'COLOR': 0xff3EB185,
  },
  UserType.cautious: {
    'TYPE_NAME': '안정추구형',
    'IMAGE_URL': 'assets/characters/research_step_3_cautious.png',
    'COMMENT':
        '이 성향은 원금 손실을 최소화하고 안정적인 수익을\n기대해요. 예금/적금보다 높은 수익을 낼 수 있다면\n일부를 변동성이 있는 상품에 투자할 의향이 있어요.',
    'PERCENT': 'N',
    'COLOR': 0xff66B3D5,
  },
  UserType.balanced: {
    'TYPE_NAME': '위험중립형',
    'IMAGE_URL': 'assets/characters/research_step_3_balanced.png',
    'COMMENT':
        '이 성향은 원금 손실 위험 대비 적당한 수익을 기대해요.\n예금/적금보다 높고 대표적인 주가 지수 수준의 수익이\n있다면 해당 수익금의 변동을 감내할 의향이 있어요.',
    'PERCENT': 'N',
    'COLOR': 0xffFAD44B,
  },
  UserType.growth: {
    'TYPE_NAME': '적극투자형',
    'IMAGE_URL': 'assets/characters/research_step_3_growth.png',
    'COMMENT':
        '이 성향은 높은 투자 수익에 따른 투자 위험이\n있음을 충분히 인식해요. 예금/적금보다\n높은 수익을 낼 수 있다면 손실 위험을 감내해요.',
    'PERCENT': 'N',
    'COLOR': 0xffFC950E,
  },
  UserType.aggresive: {
    'TYPE_NAME': '공격투자형',
    'IMAGE_URL': 'assets/characters/research_step_3_aggresive.png',
    'COMMENT':
        '이 성향은 높은 투자 수익을 위해 손실 위험을\n적극적으로 수용해요. 투자자금의 대부분을\n위험자산에 투자할 의향이 있어요.',
    'PERCENT': 'N',
    'COLOR': 0xffF94A40,
  },
};

class PostTestResultPage extends StatefulHookConsumerWidget {
  const PostTestResultPage({super.key});

  @override
  ConsumerState<PostTestResultPage> createState() => _PostTestResultPageState();
}

class _PostTestResultPageState extends ConsumerState<PostTestResultPage> {
  //UserType type = UserType.conservative;

  Future loading() async {
    //투자 성향 별 회원별 퍼센트 갱신 및 캐싱
    /**
     * int i = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        type = UserType.values[++i];
        print(type);
        if (i == 5) timer.cancel;
      });
    });
     */
  }

  @override
  void initState() {
    super.initState();

    loading();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final String? path = ref.watch(pathAfterResearchProvider);

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 347.w,
            height: 652.h,
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff374151),
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        text: '${authState.user?.nickname ?? '핀그로우'} 님은\n',
                      ),
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${user_type_resource[authState.user?.type]?['TYPE_NAME']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(
                                user_type_resource[authState
                                    .user
                                    ?.type]?['COLOR'],
                              ),
                              fontSize: 40.sp,
                            ),
                          ),
                          TextSpan(
                            text: '입니다',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Image.asset(
                  user_type_resource[authState.user?.type]?['IMAGE_URL'],
                  width: 247.r,
                  height: 247.r,
                ),

                Container(
                  height: 62.h,
                  alignment: Alignment.center,
                  child: Text(
                    user_type_resource[authState.user?.type]?['COMMENT'],
                    style: TextStyle(
                      color: Color(0xff8B8E9B),
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                  height: 48.h,
                  margin: EdgeInsets.fromLTRB(0, 13, 0, 13),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff374151),
                      ),
                      children: [
                        TextSpan(text: '핀그로우 회원 '),
                        TextSpan(
                          style: TextStyle(
                            color: Color(
                              user_type_resource[authState
                                  .user
                                  ?.type]?['COLOR'],
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          text:
                              '${user_type_resource[authState.user?.type]?['PERCENT']}%',
                        ),
                        TextSpan(text: '가\n'),

                        TextSpan(
                          style: TextStyle(
                            color: Color(
                              user_type_resource[authState
                                  .user
                                  ?.type]?['COLOR'],
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          text:
                              '${user_type_resource[authState.user?.type]?['TYPE_NAME']} ',
                        ),
                        TextSpan(text: '성향을 가지고 있어요'),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: 307.w,
                  height: 151.h,
                  padding: EdgeInsets.fromLTRB(23.w, 23.h, 23.w, 23.h),
                  decoration: BoxDecoration(
                    color: Color(0xffF7F8F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${authState.user?.nickname} 님의 목표',
                        style: TextStyle(
                          color: Color(0xff252525),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 80.w,
                            height: 75.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '목표',
                                  style: TextStyle(
                                    color: Color(0xff8B8E9B),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '필요 금액',
                                  style: TextStyle(
                                    color: Color(0xff8B8E9B),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '목표 기간',
                                  style: TextStyle(
                                    color: Color(0xff8B8E9B),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 180.w,
                            height: 75.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${authState.user?.goal}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Color(0xff252525),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${NumberFormat.decimalPattern().format(authState.user?.goal_money)} 원',
                                  style: TextStyle(
                                    color: Color(0xff252525),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${authState.user?.goal_period == 49 ? '5년 이상' : '${authState.user?.goal_period} 개월'}',
                                  style: TextStyle(
                                    color: Color(0xff252525),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              GoRouter.of(context).push(path ?? '/home');
            },
            child: Container(
              width: 347.w,
              height: 52.h,
              margin: EdgeInsets.fromLTRB(0, 14, 0, 14),
              decoration: BoxDecoration(
                color: Color(0xffFCF7E2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/home_top_logo.png',
                    width: 70.w,
                    height: 29.h,
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(6.w, 0, 6.w, 0),
                    child: Text(
                      '시작하기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
