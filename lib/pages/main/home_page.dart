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
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double progressRate = 0.00;

  late Future<RecommendProductModel> _recommendProduct;

  @override
  void initState() {
    super.initState();
    final apiRepo = ref.read(productViewModelProvider.notifier);
    _recommendProduct = apiRepo.fetchRecommendation(
      ref.read(authViewModelProvider).user!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final regions = ref.watch(regionProvider);
    final apiRepo = ref.read(productViewModelProvider.notifier);

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
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Row(
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
                              '${((authState.user!.saved_money ?? 0) / (authState.user!.goal_money ?? 1) * 100).round()}%',
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
                                GoRouter.of(context).push('/home/goal_modify');
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
                                  (authState.user!.goal_money ?? 0) <=
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
                                      (authState.user!.saved_money ?? 0) /
                                      (authState.user!.goal_money ?? 1),
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
                                    (authState.user!.saved_money ?? 0) /
                                    (authState.user!.goal_money ?? 1) -
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

              SizedBox(
                width: 338.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 213.w,
                      height: 98.h,
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Colors.black38,
                            blurStyle: BlurStyle.normal,
                            offset: Offset(0, 2.5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: '지금 '),
                                TextSpan(
                                  text:
                                      regions?[authState.user?.region?.split(
                                            '-',
                                          )[2]]
                                          ?.alias ??
                                      '???',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '에서 가장 '),
                                TextSpan(
                                  text: '인기있는 정책',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                              style: TextStyle(
                                color: Color(0xff374151),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/policy_list');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 184.w,
                              height: 43.h,
                              decoration: BoxDecoration(
                                color: Color(0xffFFD16F),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '확인하러 가기',
                                style: TextStyle(
                                  color: Color(0xff374151),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      /// TODO:
                      /// 지역 선택 or 변경으로 이동
                      onTap: () {},
                      child: Container(
                        width: 115.w,
                        height: 98.h,
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        decoration: BoxDecoration(
                          color: Color(0xffE3F1FD),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: Colors.black38,
                              blurStyle: BlurStyle.normal,
                              offset: Offset(0, 2.5),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 0,
                              child: Text(
                                regions?[authState.user?.region?.split('-')[2]]
                                        ?.alias ??
                                    '???',
                                style: TextStyle(
                                  color: Color(0xffBBBBBB),
                                  fontSize: 50.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              child: Image.asset(
                                'assets/characters/main_region.png',
                                width: 83.r,
                                height: 83.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Flex(
                direction: Axis.vertical,
                children: [
                  Container(
                    width: 338.w,
                    height: 398.h,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    padding: EdgeInsets.fromLTRB(15.w, 20.h, 12.w, 15.h),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Colors.black38,
                          blurStyle: BlurStyle.normal,
                          offset: Offset(0, 2.5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Color(0xff374151),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: authState.user?.nickname,
                                          style: TextStyle(
                                            color: Color(0xff0CA361),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),

                                        TextSpan(text: ' 님을 위한 저축/투자 조합'),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        Text(
                                          '더 보러가가',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff0CA361),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                            2,
                                            0,
                                            0,
                                            0,
                                          ),
                                          child: Image.asset(
                                            'assets/icons/right_arrow.png',
                                            width: 5.w,
                                            height: 9.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '월 35만원 · 12개월 · 적금+채권 혼합',
                                    style: TextStyle(
                                      color: Color(0xff6B7280),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        FutureBuilder(
                          future: _recommendProduct,
                          builder: (context, snapshot) {
                            // 1. 로딩 중 상태 처리
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            // 2. 에러 발생 상태 처리
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('에러: ${snapshot.error}'),
                              );
                            }

                            // 3. 데이터가 없거나 비어있는 경우 처리
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Center(child: Text('데이터가 없습니다.'));
                            }

                            final products = snapshot.data!.products;

                            return Expanded(
                              child: ListView.builder(
                                itemCount: products!.length,
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 80.h,
                                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xffD0D0D0),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _suggTag(),
                                            Text(
                                              products[index].productName!,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff374151),
                                              ),
                                            ),
                                            Text(
                                              '${products[index].term}개월 · 금리 최대 ${products[index].monthlyAmount}(월)',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              products[index].bankName!,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff6B7280),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),

                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xffD0D0D0),
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

  Widget _suggTag() {
    return Container(
      width: 34.w,
      height: 17.h,
      decoration: BoxDecoration(
        color: Color(0xffffeadb),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/fire.png', width: 10.r, height: 10.r),
          Text(
            '추천',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xff374151),
            ),
          ),
        ],
      ),
    );
  }
}
