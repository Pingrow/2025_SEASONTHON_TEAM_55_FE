import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget noPolicy() {
  return Expanded(
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/no_policy.png',
            width: 203.r,
            height: 203.r,
          ),

          Text(
            '선택하신 지역에는',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff374151),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '현재 등록된 청년 정책이 없어요',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff374151),
                ),
              ),
              Image.asset(
                'assets/icons/crying_face.png',
                width: 21.r,
                height: 21.r,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget noProduct() {
  return Expanded(
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/no_policy.png',
            width: 203.r,
            height: 203.r,
          ),
          Text(
            '사용자 님에게',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff374151),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '알맞은 상품을 불러오지 못했어요',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff374151),
                ),
              ),
              Image.asset(
                'assets/icons/crying_face.png',
                width: 21.r,
                height: 21.r,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget error() {
  return Expanded(
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/no_policy.png',
            width: 203.r,
            height: 203.r,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '자료를 불러오다 문제가 발생했어요.',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff374151),
                ),
              ),
              Image.asset(
                'assets/icons/crying_face.png',
                width: 21.r,
                height: 21.r,
              ),
            ],
          ),
          Text(
            '문제가 계속 발생한다면 문의를 남겨주세요.',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff374151),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget notReady() {
  return Expanded(
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/no_policy.png',
            width: 203.r,
            height: 203.r,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '열심히 준비중인 서비스에요 ',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff374151),
                ),
              ),
              Image.asset(
                'assets/icons/crying_face.png',
                width: 21.r,
                height: 21.r,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
