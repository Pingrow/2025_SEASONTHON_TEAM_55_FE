import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/model/recommend_product_model.dart';
import 'package:pin_grow/providers/region_provider.dart';
import 'package:pin_grow/repository/error.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class ProfilePage extends StatefulHookConsumerWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  double progressRate = 0.00;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(color: Color(0xffffffff)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 338.w,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go('/home');
                      },
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(
                          10.w,
                          10.h,
                          10.w,
                          10.h,
                        ),
                        child: Image.asset(
                          'assets/icons/back.png',
                          width: 10.w,
                          height: 16.h,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo/home_top_logo.png',
                          width: 79.w,
                          height: 29.h,
                        ),
                        Image.asset(
                          'assets/logo/home_top_logo_heart.png',
                          width: 23.r,
                          height: 23.r,
                        ),
                      ],
                    ),
                    SizedBox(width: 20.w, height: 26.h),
                  ],
                ),
              ),

              Container(
                width: 338.w,
                height: 192.h,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                padding: EdgeInsets.fromLTRB(25.w, 22.h, 25.w, 22.h),
                decoration: BoxDecoration(
                  color: Color(0xff0ca361),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                      color: Colors.black45,
                      blurStyle: BlurStyle.normal,
                      offset: Offset(0, 2.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'D-${authState.user?.goal_period ?? '??'}개월',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              '${authState.user == null ? '-' : ((authState.user?.saved_money ?? 0) / (authState.user?.goal_money ?? 1) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFFD16F),
                              ),
                            ),

                            Text(
                              '진행중',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffffff),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                GoRouter.of(
                                  context,
                                ).push('/profile/goal_modify');
                              },
                              child: Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(
                                  10,
                                  0,
                                  0,
                                  0,
                                ),
                                child: Image.asset(
                                  'assets/icons/setting.png',
                                  width: 16.r,
                                  height: 16.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Text(
                      authState.user?.goal ?? '???',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffffffff),
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: NumberFormat.decimalPattern().format(
                              authState.user?.goal_money ?? 0,
                            ),
                            style: TextStyle(
                              fontSize:
                                  (authState.user?.goal_money ?? 0) <=
                                      1000000000000
                                  ? 27.sp
                                  : 21.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          TextSpan(text: ' 원'),
                        ],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffFDF8E3),
                        ),
                      ),
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),

                    Container(
                      height: 65.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 288.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: Color(0xffffffff),
                            ),
                          ),

                          Positioned(
                            ///TODO:
                            ///진행도에 따른 길이변화
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width:
                                  9.w +
                                  (288.w - 9.w) *
                                      (authState.user?.saved_money ?? 0) /
                                      (authState.user?.goal_money ?? 1),
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Color(0xffFFD16F),
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 0,
                            left:
                                (288.w - 9.w) *
                                    (authState.user?.saved_money ?? 0) /
                                    (authState.user?.goal_money ?? 1) -
                                20.w,
                            child: Image.asset(
                              'assets/characters/main_progress_bar.png',
                              width: 48.r,
                              height: 48.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            right: 15.w,
            bottom: 15.h,
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/icons/chat_bot_icon.png',
                width: 60.r,
                height: 60.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
