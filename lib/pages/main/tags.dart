import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget suggTag() {
  return Container(
    width: 34.w,
    height: 17.h,
    margin: EdgeInsets.fromLTRB(0, 0, 6.w, 0),
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

Widget popTag() {
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
          '인기',
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
