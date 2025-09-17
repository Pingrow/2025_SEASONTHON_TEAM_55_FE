import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

import 'package:webview_flutter/webview_flutter.dart';

class SpecialProduct extends StatefulHookConsumerWidget {
  const SpecialProduct({super.key});

  @override
  ConsumerState<SpecialProduct> createState() => _SpecialProductState();
}

class _SpecialProductState extends ConsumerState<SpecialProduct> {
  final String urlString =
      'https://mmall.nonghyup.com/servlet/SFDPM0130R.view?Type=S';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final authState = ref.watch(authViewModelProvider);
    //final apiRepo = ref.read(policyViewModelProvider.notifier);

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
                //width: 338.w,
                //height: 39.h,
                margin: EdgeInsets.fromLTRB(
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  20.h,
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  10.h,
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pop();
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
                margin: EdgeInsets.fromLTRB(
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  10.h,
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  18.h,
                ),
                child: Column(
                  children: [
                    Row(
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
                              TextSpan(text: '전국 농·축협 '),
                              TextSpan(
                                text: '특판',
                                style: TextStyle(color: Color(0xff0CA361)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '클릭하면 아래의 상품 및 혜택을 확인할 수 있어요',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                    '/special_web_view',
                    /**extra: 'savingsTitle'*/
                  );
                },
                child: Container(
                  width: 338.w,
                  height: 69.h,
                  margin: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
                  padding: EdgeInsets.fromLTRB(17.w, 13.h, 17.w, 13.h),
                  decoration: BoxDecoration(
                    color: Color(0xffFCF7E2),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '특판 적금',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff0CA361),
                            ),
                          ),
                          Text(
                            '이자 높은 적rma 상품',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff374151),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 3.h),
                        child: Image.asset(
                          'assets/icons/right_arrow.png',
                          width: 10.w,
                          height: 16.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                    '/special_web_view',
                    extra: 'installmentSavingsListArea1',
                    /** 'depositTitle'*/
                  );
                },
                child: Container(
                  width: 338.w,
                  height: 69.h,
                  margin: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
                  padding: EdgeInsets.fromLTRB(17.w, 13.h, 17.w, 13.h),
                  decoration: BoxDecoration(
                    color: Color(0xffEFFFE2),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '특판 예금',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff0CA361),
                            ),
                          ),
                          Text(
                            '평균 이자보다 높은 예금',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff374151),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 3.h),
                        child: Image.asset(
                          'assets/icons/right_arrow.png',
                          width: 10.w,
                          height: 16.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                    '/special_web_view',
                    extra: 'depositListArea1',
                    /** 'target-section'*/
                  );
                },
                child: Container(
                  width: 338.w,
                  height: 69.h,
                  margin: EdgeInsets.fromLTRB(0, 8.h, 0, 8.h),
                  padding: EdgeInsets.fromLTRB(17.w, 13.h, 17.w, 13.h),
                  decoration: BoxDecoration(
                    color: Color(0xffE3FFF3),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '세금 우대 혜택',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff0CA361),
                            ),
                          ),
                          Text(
                            '세금 덜 내는 방법',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff374151),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 3.h),
                        child: Image.asset(
                          'assets/icons/right_arrow.png',
                          width: 10.w,
                          height: 16.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpecialProductWebView extends StatefulHookConsumerWidget {
  final String? section;
  const SpecialProductWebView({super.key, this.section});

  @override
  ConsumerState<SpecialProductWebView> createState() =>
      _SpecialProductWebViewState();
}

class _SpecialProductWebViewState extends ConsumerState<SpecialProductWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            Future.delayed(const Duration(milliseconds: 800), () {
              if (widget.section != null && widget.section!.isNotEmpty) {
                controller.runJavaScript('''
                try {
                   document.getElementById('${widget.section}').scrollIntoView({ behavior: 'smooth' });
                 
                } catch (e) {
                }
              ''');
              }
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://mmall.nonghyup.com/servlet/SFDPM0130R.view?Type=S'),
      );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final apiRepo = ref.read(policyViewModelProvider.notifier);

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
                //width: 338.w,
                //height: 39.h,
                margin: EdgeInsets.fromLTRB(
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  20.h,
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  10.h,
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pop();
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
              Expanded(child: WebViewWidget(controller: controller)),
            ],
          ),
        ],
      ),
    );
  }
}
