import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/model/bond_product_model.dart';
import 'package:pin_grow/model/product_model.dart';
import 'package:pin_grow/model/region_model.dart';
import 'package:pin_grow/model/policy_model.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/providers/region_provider.dart';
import 'package:pin_grow/pages/main/error.dart';
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

  int tap_idx = 0;
  int idx = 0;
  String hintValue = '';

  late Future<List<ProductModel>> _productsFuture;
  late Future<(List<BondProductModel>, List<BondProductModel>)> _bondsFuture;

  @override
  void initState() {
    super.initState();

    final authState = ref.read(authViewModelProvider);
    final apiRepo = ref.read(productViewModelProvider.notifier);

    if (authState.user == null) {
      tap_idx = -1;
      idx = 3;

      Timer(Duration(milliseconds: 200), () {
        GoRouter.of(context).push('/product_list/product_login_popup');
      });
    }

    _productsFuture = apiRepo.fetchDepositList();
    _bondsFuture = apiRepo.fetchBondsList();
  }

  Map<int, Widget> get _products => {
    0: FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        // 1. 로딩 중 상태 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. 에러 발생 상태 처리
        if (snapshot.hasError) {
          return error();
        }

        // 3. 데이터가 없거나 비어있는 경우 처리
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return noProduct();
        }

        // 4. 데이터 수신 성공 시 UI 구성
        final products = snapshot.data!;

        ScrollController scrollController = ScrollController();

        // 전체를 스크롤 가능하게 만듦
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width - 348.w) / 2,
              0,
              (MediaQuery.of(context).size.width - 348.w) / 2,
              0,
            ),
            controller: scrollController,
            child: Container(
              //width: 338.w,
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
                        width: 338.w,
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
                                Container(
                                  width: 220,
                                  child: Text(
                                    products[index].productName!,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff374151),
                                    ),
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
          ),
        );
      },
    ),
    1: FutureBuilder<(List<BondProductModel>, List<BondProductModel>)>(
      future: _bondsFuture,
      builder: (context, snapshot) {
        // 1. 로딩 중 상태 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. 에러 발생 상태 처리
        if (snapshot.hasError) {
          return error();
        }

        // 3. 데이터가 없거나 비어있는 경우 처리
        if (!snapshot.hasData ||
            snapshot.data!.$1.isEmpty ||
            snapshot.data!.$2.isEmpty) {
          return noProduct();
        }

        // 4. 데이터 수신 성공 시 UI 구성
        final sortByInterest = snapshot.data!.$1;
        final sortByMaturity = snapshot.data!.$2;

        ScrollController scrollController = ScrollController();

        // 전체를 스크롤 가능하게 만듦
        return Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width - 348.w) / 2,
              0,
              (MediaQuery.of(context).size.width - 348.w) / 2,
              0,
            ),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20.w,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5.h),
                  margin: EdgeInsets.only(top: 25.h, bottom: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffD0D0D0), width: 1),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Color(0xff374151),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: '금융채 '),
                        const TextSpan(
                          text: 'Top 5',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' (금리순)'),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero, // ListView의 기본 패딩 제거
                  physics:
                      const NeverScrollableScrollPhysics(), // 부모 스크롤과 충돌 방지
                  shrinkWrap: true,
                  itemCount: sortByInterest.length,
                  itemBuilder: (context, index) {
                    // 재사용 가능한 메소드 호출
                    return Container(
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
                                sortByInterest[index].bondIsurNm!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Container(
                                width: 220,
                                child: Text(
                                  sortByInterest[index].isinCdNm!,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff374151),
                                  ),
                                ),
                              ),
                              Text(
                                '만기일 ${sortByInterest[index].bondExprDt} · 금리 최대 ${sortByInterest[index].bondSrfcInrt}%(연)',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
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
                Container(
                  width: MediaQuery.of(context).size.width - 20.w,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5.h),
                  margin: EdgeInsets.only(top: 25.h, bottom: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffD0D0D0), width: 1),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Color(0xff374151),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: '금융채 '),
                        const TextSpan(
                          text: 'Top 5',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' (만기순)'),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero, // ListView의 기본 패딩 제거
                  physics:
                      const NeverScrollableScrollPhysics(), // 부모 스크롤과 충돌 방지
                  shrinkWrap: true,
                  itemCount: sortByMaturity.length,
                  itemBuilder: (context, index) {
                    // 재사용 가능한 메소드 호출
                    return Container(
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
                                sortByMaturity[index].bondIsurNm!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Container(
                                width: 220,
                                child: Text(
                                  sortByMaturity[index].isinCdNm!,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff374151),
                                  ),
                                ),
                              ),
                              Text(
                                '만기일 ${sortByMaturity[index].bondExprDt} · 금리 최대 ${sortByMaturity[index].bondSrfcInrt}%(연)',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
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
    2: notReady(),
    3: Container(),
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
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      //width: 338.w,
                      //height: 39.h,
                      margin: EdgeInsets.fromLTRB(
                        (MediaQuery.of(context).size.width - 338.w) / 2 - 10.w,
                        20.h,
                        (MediaQuery.of(context).size.width - 338.w) / 2 - 10.w,
                        10.h,
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    Container(
                      width: 338.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  text:
                                      authState.user?.nickname ??
                                      '???', //'핀그로우',
                                  style: TextStyle(color: Color(0xff0CA361)),
                                ),

                                TextSpan(text: ' 님, 이런 상품은 어떠세요?'),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                              padding: EdgeInsetsGeometry.fromLTRB(
                                0,
                                0,
                                14.r,
                                0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (authState.user == null) {
                                    setState(() {
                                      tap_idx = -1;
                                      idx = 3;
                                    });

                                    Timer(Duration(milliseconds: 200), () {
                                      GoRouter.of(context).push(
                                        '/product_list/product_login_popup',
                                      );
                                    });
                                  } else {
                                    setState(() {
                                      tap_idx = 4;
                                      idx = 0;
                                      _productsFuture = apiRepo.fetchSearchList(
                                        '우리은행',
                                        /**_controller.text*/
                                      );
                                    });
                                  }
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (tap_idx != 0) {
                            if (authState.user == null) {
                              setState(() {
                                tap_idx = -1;
                                idx = 3;
                              });

                              Timer(Duration(milliseconds: 200), () {
                                GoRouter.of(
                                  context,
                                ).push('/product_list/product_login_popup');
                              });
                            } else {
                              setState(() {
                                tap_idx = 0;
                                idx = 0;
                                hintValue = '';
                                _controller.text = '';
                                _productsFuture = apiRepo.fetchDepositList();
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 77.w,
                          height: 36.h,
                          margin: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(selectConfig[tap_idx == 0]!["COLOR"]),
                            border: Border.all(
                              color: Color(
                                selectConfig[tap_idx == 0]!["STROKE_COLOR"],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            '정기예금',
                            style: TextStyle(
                              color: Color(
                                selectConfig[tap_idx == 0]!["FONT_COLOR"],
                              ),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (tap_idx != 1) {
                            if (authState.user == null) {
                              setState(() {
                                tap_idx = -1;
                                idx = 3;
                              });

                              Timer(Duration(milliseconds: 200), () {
                                GoRouter.of(
                                  context,
                                ).push('/product_list/product_login_popup');
                              });
                            } else {
                              setState(() {
                                tap_idx = 1;
                                idx = 0;
                                hintValue = '';
                                _controller.text = '';
                                _productsFuture = apiRepo.fetchSavingsList();
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 77.w,
                          height: 36.h,
                          margin: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(selectConfig[tap_idx == 1]!["COLOR"]),
                            border: Border.all(
                              color: Color(
                                selectConfig[tap_idx == 1]!["STROKE_COLOR"],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            '적금',
                            style: TextStyle(
                              color: Color(
                                selectConfig[tap_idx == 1]!["FONT_COLOR"],
                              ),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (tap_idx != 2) {
                            if (authState.user == null) {
                              setState(() {
                                tap_idx = -1;
                                idx = 3;
                              });

                              Timer(Duration(milliseconds: 200), () {
                                GoRouter.of(
                                  context,
                                ).push('/product_list/product_login_popup');
                              });
                            } else {
                              setState(() {
                                tap_idx = 2;
                                idx = 1;
                                hintValue = '';
                                _controller.text = '';
                                _bondsFuture = apiRepo.fetchBondsList();
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 77.w,
                          height: 36.h,
                          margin: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(selectConfig[tap_idx == 2]!["COLOR"]),
                            border: Border.all(
                              color: Color(
                                selectConfig[tap_idx == 2]!["STROKE_COLOR"],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            '채권',
                            style: TextStyle(
                              color: Color(
                                selectConfig[tap_idx == 2]!["FONT_COLOR"],
                              ),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (tap_idx != 3) {
                            if (authState.user == null) {
                              setState(() {
                                tap_idx = -1;
                                idx = 3;
                              });

                              Timer(Duration(milliseconds: 200), () {
                                GoRouter.of(
                                  context,
                                ).push('/product_list/product_login_popup');
                              });
                            } else {
                              setState(() {
                                tap_idx = 3;
                                idx = 2;
                                hintValue = '';
                                _controller.text = '';
                                //_productsFuture = apiRepo.fetchDepositList();
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 77.w,
                          height: 36.h,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(selectConfig[tap_idx == 3]!["COLOR"]),
                            border: Border.all(
                              color: Color(
                                selectConfig[tap_idx == 3]!["STROKE_COLOR"],
                              ),
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            'ETF',
                            style: TextStyle(
                              color: Color(
                                selectConfig[tap_idx == 3]!["FONT_COLOR"],
                              ),
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

              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width - 20.w,
                  child: _products[idx],
                ),
              ),
            ],
          ),

          Positioned(
            right: 15.w,
            bottom: 15.h,
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/chat_bot');
              },
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

/**
 * FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  // 1. 로딩 중 상태 처리
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. 에러 발생 상태 처리
                  if (snapshot.hasError) {
                    return error();
                  }

                  // 3. 데이터가 없거나 비어있는 경우 처리
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return noProduct();
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
           
 */
