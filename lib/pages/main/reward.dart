import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

enum TapStatus { notSelected, selected, load }

Map<TapStatus, Map<String, dynamic>> tapConfig = {
  TapStatus.notSelected: {
    "COLOR": 0xffF1F4F6,
    "FONT_COLOR": 0xffABABAB,
    "SHADOW": null,
  },
  TapStatus.selected: {
    "COLOR": 0xffFFFFFF,
    "FONT_COLOR": 0xff374151,
    "SHADOW": [
      BoxShadow(
        blurRadius: 3.0,
        color: Colors.black38,
        blurStyle: BlurStyle.normal,
        offset: Offset(0, 2.5),
      ),
    ],
  },
  TapStatus.load: {
    "COLOR": 0xffC3E4D8,
    "FONT_COLOR": 0xff374151,
    "SHADOW": [
      BoxShadow(
        blurRadius: 3.0,
        color: Colors.black38,
        blurStyle: BlurStyle.normal,
        offset: Offset(0, 2.5),
      ),
    ],
  },
};

class RewardPage extends StatefulHookConsumerWidget {
  const RewardPage({super.key});

  @override
  ConsumerState<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends ConsumerState<RewardPage> {
  int idx = 0;
  List<TapStatus> tapStatus = [TapStatus.selected, TapStatus.notSelected];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final apiRepo = ref.read(policyViewModelProvider.notifier);

    int pt = 25397;

    List<Widget> contents = [
      Container(
        margin: EdgeInsets.fromLTRB(0, 10.h, 0, 0.h),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4.h, 0, 0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff374151),
                                width: 3,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                              children: [
                                TextSpan(
                                  text: '최대',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: '30%',
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 224.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/expedia.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '익스피디아',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 20.8%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/jejupass.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '제주패스',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 21.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/yeogi.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '여기어떄',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 23.6%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
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

              Container(
                margin: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4.h, 0, 0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff374151),
                                width: 3,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                              children: [
                                TextSpan(
                                  text: '최대',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: '20%',
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 224.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/klook.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '클룩',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 10.6%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/nol.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'NOL',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 11.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/rakuten.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '라쿠텐트래블',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 12,5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/tripdotcom.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '트립닷컴',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 13.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
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

              Container(
                margin: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4.h, 0, 0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff374151),
                                width: 3,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                              children: [
                                TextSpan(
                                  text: '최대',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: '10%',
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 224.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/usimsa.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '유심사',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 8.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xff6B7280),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/agoda.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '아고다',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 5.6%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/trip/hotels_combine.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '호텔스컴바인',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 4.3%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
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
            ],
          ),
        ),
      ),

      Container(
        margin: EdgeInsets.fromLTRB(0, 10.h, 0, 0.h),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4.h, 0, 0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff374151),
                                width: 3,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                              children: [
                                TextSpan(
                                  text: '최대',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: '30%',
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 224.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/ali_express.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '알리익스프레스',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 20.8%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/aladin.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '알라딘',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 21.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/kyobo.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '교보문고',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 23.6%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
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

              Container(
                margin: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4.h, 0, 0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff374151),
                                width: 3,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                              children: [
                                TextSpan(
                                  text: '최대',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: '20%',
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 224.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/gmarket.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '지마켓',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 10.6%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/naver_store.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '네이버스토어',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 11.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xffE53524),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/coupang.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '쿠팡',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 12,5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/11th_street.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '11번가',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 13.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
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

              Container(
                margin: EdgeInsets.fromLTRB(0, 20.h, 0, 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4.h, 0, 0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xff374151),
                                width: 3,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                              children: [
                                TextSpan(
                                  text: '최대',
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: '10%',
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 224.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/yes24.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '예스24',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 8.5%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/auction.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '옥션',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 5.6%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.r,
                                      height: 60.r,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/shopping/oliveyoung.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '올리브영',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff374151),
                                      ),
                                    ),

                                    Text(
                                      '(최대 4.3%)',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff6B7280),
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
            ],
          ),
        ),
      ),
    ];

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
                  10.h,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff374151),
                            ),
                            children: [
                              TextSpan(
                                text: '핀그로우',
                                style: TextStyle(color: Color(0xff0CA361)),
                              ),

                              TextSpan(text: '를 통해 '),
                              TextSpan(
                                text: '결제',
                                style: TextStyle(color: Color(0xff0CA361)),
                              ),

                              TextSpan(text: '하고 '),
                              TextSpan(
                                text: '적립',
                                style: TextStyle(color: Color(0xff0CA361)),
                              ),

                              TextSpan(text: '받아요'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '최대 28%의 리워드를 받을 수 있어요',
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
              Container(
                margin: EdgeInsets.fromLTRB(
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  10.h,
                  (MediaQuery.of(context).size.width - 328.w) / 2,
                  10.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff374151),
                        ),
                        children: [
                          TextSpan(text: '보유 포인트 : '),
                          TextSpan(
                            style: TextStyle(fontSize: 23.sp),
                            children: [
                              TextSpan(
                                text: NumberFormat.decimalPattern().format(pt),
                                style: TextStyle(color: Color(0xff0FA564)),
                              ),
                              TextSpan(text: ' P'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 111.w,
                        height: 36.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xffC3E4D8),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              color: Colors.black38,
                              blurStyle: BlurStyle.normal,
                              offset: Offset(0, 2.5),
                            ),
                          ],
                        ),
                        child: Text(
                          '사용하러 가기',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff374151),
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
                  margin: EdgeInsets.fromLTRB(
                    (MediaQuery.of(context).size.width - 328.w) / 2,
                    10.h,
                    (MediaQuery.of(context).size.width - 328.w) / 2,
                    10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffF1F4F6),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (tapStatus[0] == TapStatus.notSelected) {
                            setState(() {
                              idx = 0;
                              tapStatus[0] = TapStatus.selected;
                              tapStatus[1] = TapStatus.notSelected;
                            });
                          }
                        },
                        child: Container(
                          width: 155.w,
                          height: 36.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(tapConfig[tapStatus[0]]!["COLOR"]),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: tapConfig[tapStatus[0]]!["SHADOW"],
                          ),
                          child: Text(
                            '여행',
                            style: TextStyle(
                              color: Color(
                                tapConfig[tapStatus[0]]!["FONT_COLOR"],
                              ),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          if (tapStatus[1] == TapStatus.notSelected) {
                            setState(() {
                              idx = 1;
                              tapStatus[1] = TapStatus.selected;
                              tapStatus[0] = TapStatus.notSelected;
                            });
                          }
                        },
                        child: Container(
                          width: 155.w,
                          height: 36.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(tapConfig[tapStatus[1]]!["COLOR"]),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: tapConfig[tapStatus[1]]!["SHADOW"],
                          ),
                          child: Text(
                            '쇼핑',
                            style: TextStyle(
                              color: Color(
                                tapConfig[tapStatus[1]]!["FONT_COLOR"],
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
                  margin: EdgeInsets.fromLTRB(
                    (MediaQuery.of(context).size.width - 328.w) / 2,
                    10.h,
                    (MediaQuery.of(context).size.width - 328.w) / 2,
                    10.h,
                  ),
                  child: contents[idx],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
