import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/model/product_model.dart';
import 'package:pin_grow/model/region_model.dart';
import 'package:pin_grow/model/policy_model.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/providers/region_provider.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Map<bool, Map<String, dynamic>> selectConfig = {
  true: {
    // Selected
    "COLOR": 0x330CA361,
    "STROKE_COLOR": 0xff0CA361,
    "FONT_COLOR": 0xff374151,
  },
  false: {
    // NOT Selected
    "COLOR": 0xffF7F7F7,
    "STROKE_COLOR": 0xffE7E7E7,
    "FONT_COLOR": 0xffABABAB,
  },
};

class ProductListPage extends StatefulHookConsumerWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  GlobalKey _globalKey = GlobalKey();

  TextEditingController _controller = TextEditingController();

  int idx = 0;
  String hintValue = '';

  late Future<List<ProductModel>> _depositsFuture;
  late Future<List<ProductModel>> _savingsFuture;
  late Future<List<ProductModel>> _searchFuture;

  @override
  void initState() {
    super.initState();

    final apiRepo = ref.read(productViewModelProvider.notifier);

    _depositsFuture = apiRepo.fetchDepositList();
    _savingsFuture = apiRepo.fetchSavingsList();
    _searchFuture = apiRepo.fetchSearchList(null);
  }

  Map<int, Widget> get _products => {
    0: FutureBuilder<List<ProductModel>>(
      future: _depositsFuture,
      builder: (context, snapshot) {
        // 1. 로딩 중 상태 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. 에러 발생 상태 처리
        if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        }

        // 3. 데이터가 없거나 비어있는 경우 처리
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        // 4. 데이터 수신 성공 시 UI 구성
        final products = snapshot.data!;

        ScrollController scrollController = ScrollController();

        // 전체를 스크롤 가능하게 만듦
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero, // ListView의 기본 패딩 제거
                  physics:
                      const NeverScrollableScrollPhysics(), // 부모 스크롤과 충돌 방지
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    // 재사용 가능한 메소드 호출
                    return Container(
                      height: 48.h,
                      margin: EdgeInsets.fromLTRB(0, 15.h, 0, 15.h),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].bankName!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                products[index].productName!,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff374151),
                                ),
                              ),
                              Text(
                                '1~${products[index].bestTerm}개월 · 금리 최대 ${products[index].bestRate}(연)',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '추천기간: ${products[index].bestTerm}개월',
                                style: TextStyle(
                                  fontSize: 12.sp,
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
              ],
            ),
          ),
        );
      },
    ),
    1: FutureBuilder<List<ProductModel>>(
      future: _savingsFuture,
      builder: (context, snapshot) {
        // 1. 로딩 중 상태 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. 에러 발생 상태 처리
        if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        }

        // 3. 데이터가 없거나 비어있는 경우 처리
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        // 4. 데이터 수신 성공 시 UI 구성
        final products = snapshot.data!;

        ScrollController scrollController = ScrollController();

        // 전체를 스크롤 가능하게 만듦
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero, // ListView의 기본 패딩 제거
                  physics:
                      const NeverScrollableScrollPhysics(), // 부모 스크롤과 충돌 방지
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    // 재사용 가능한 메소드 호출
                    return Container(
                      height: 48.h,
                      margin: EdgeInsets.fromLTRB(0, 15.h, 0, 15.h),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].bankName!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                products[index].productName!,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff374151),
                                ),
                              ),
                              Text(
                                '1~${products[index].bestTerm}개월 · 금리 최대 ${products[index].bestRate}(연)',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '추천기간: ${products[index].bestTerm}개월',
                                style: TextStyle(
                                  fontSize: 12.sp,
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
              ],
            ),
          ),
        );
      },
    ),
    2: Container(),
    3: FutureBuilder<List<ProductModel>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        // 1. 로딩 중 상태 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. 에러 발생 상태 처리
        if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        }

        // 3. 데이터가 없거나 비어있는 경우 처리
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        }

        // 4. 데이터 수신 성공 시 UI 구성
        final products = snapshot.data!;

        ScrollController scrollController = ScrollController();

        // 전체를 스크롤 가능하게 만듦
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero, // ListView의 기본 패딩 제거
                  physics:
                      const NeverScrollableScrollPhysics(), // 부모 스크롤과 충돌 방지
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    // 재사용 가능한 메소드 호출
                    return Container(
                      height: 48.h,
                      margin: EdgeInsets.fromLTRB(0, 15.h, 0, 15.h),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].bankName!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                products[index].productName!,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff374151),
                                ),
                              ),
                              Text(
                                '1~${products[index].bestTerm}개월 · 금리 최대 ${products[index].bestRate}(연)',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '추천기간: ${products[index].bestTerm}개월',
                                style: TextStyle(
                                  fontSize: 12.sp,
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
              ],
            ),
          ),
        );
      },
    ),
  };

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
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
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 338.w,
                  height: 39.h,
                  margin: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).pop();
                        },
                        child: Image.asset(
                          'assets/icons/back.png',
                          width: 10.w,
                          height: 16.h,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff374151),
                        ),
                        children: [
                          TextSpan(
                            text: authState.user?.nickname ?? '핀그로우',
                            style: TextStyle(color: Color(0xff0CA361)),
                          ),

                          TextSpan(text: ' 님, 이런 상품은 어떠세요?'),
                        ],
                      ),
                    ),
                  ],
                ),

                Container(
                  width: 338.w,
                  height: 47.h,
                  margin: EdgeInsets.fromLTRB(0, 12.h, 0, 6.h),
                  child: Form(
                    key: _globalKey,
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: hintValue,
                        hintStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6B7280),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide.none,
                        ),

                        contentPadding: EdgeInsetsGeometry.fromLTRB(
                          25.w,
                          12.h,
                          10.w,
                          12.h,
                        ),

                        filled: true,
                        fillColor: Color(0xffF1F4F6),

                        suffixIcon: Padding(
                          padding: EdgeInsetsGeometry.fromLTRB(0, 0, 14.r, 0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                idx = 3;
                                _searchFuture = apiRepo.fetchSearchList(
                                  '우리은행',
                                  /**_controller.text*/
                                );
                              });
                            },
                            child: Image.asset(
                              'assets/icons/search_button.png',
                              width: 34.r,
                              height: 34.r,
                            ),
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 48.r,
                          maxHeight: 34.r,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          FittedBox(
            fit: BoxFit.fill,
            child: Container(
              width: 338.w,
              height: 47.h,
              margin: EdgeInsets.fromLTRB(0, 6.h, 0, 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (idx != 0) {
                        setState(() {
                          idx = 0;
                          hintValue = '';
                          _controller.text = '';
                          _depositsFuture = apiRepo.fetchDepositList();
                        });
                      }
                    },
                    child: Container(
                      width: 77.w,
                      height: 36.h,
                      margin: EdgeInsets.fromLTRB(0, 0, 12.w, 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(selectConfig[idx == 0]!["COLOR"]),
                        border: Border.all(
                          color: Color(selectConfig[idx == 0]!["STROKE_COLOR"]),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        '정기예금',
                        style: TextStyle(
                          color: Color(selectConfig[idx == 0]!["FONT_COLOR"]),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      if (idx != 1) {
                        setState(() {
                          idx = 1;
                          hintValue = '';
                          _controller.text = '';
                          _savingsFuture = apiRepo.fetchSavingsList();
                        });
                      }
                    },
                    child: Container(
                      width: 77.w,
                      height: 36.h,
                      margin: EdgeInsets.fromLTRB(0, 0, 12.w, 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(selectConfig[idx == 1]!["COLOR"]),
                        border: Border.all(
                          color: Color(selectConfig[idx == 1]!["STROKE_COLOR"]),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        '적금',
                        style: TextStyle(
                          color: Color(selectConfig[idx == 1]!["FONT_COLOR"]),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      if (idx != 2) {
                        setState(() {
                          idx = 2;
                          hintValue = '';
                          _controller.text = '';
                          //TODO: 채권 api
                        });
                      }
                    },
                    child: Container(
                      width: 77.w,
                      height: 36.h,
                      margin: EdgeInsets.fromLTRB(0, 0, 12.w, 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(selectConfig[idx == 2]!["COLOR"]),
                        border: Border.all(
                          color: Color(selectConfig[idx == 2]!["STROKE_COLOR"]),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        '채권',
                        style: TextStyle(
                          color: Color(selectConfig[idx == 2]!["FONT_COLOR"]),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(child: Container(child: _products[idx])),
        ],
      ),
    );
  }
}
