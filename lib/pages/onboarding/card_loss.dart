import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget cardLosLevel_1(BuildContext context) {
  return Column(
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff374151),
          ),
          children: [
            TextSpan(text: '"손실은 '),
            TextSpan(
              text: '절대',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' 감당 못해요"'),
          ],
        ),
      ),

      Container(
        margin: EdgeInsets.fromLTRB(0, 21, 0, 21),
        child: Image.asset(
          'assets/characters/research_step_2_nope.png',
          width: 172,
          height: 172,
        ),
      ),
    ],
  );
}

Widget cardLosLevel_2(BuildContext context) {
  return Column(
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff374151),
          ),
          children: [
            TextSpan(
              text: '"10% 이내',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '라면 감당 가능해요"'),
          ],
        ),
      ),

      Container(
        margin: EdgeInsets.fromLTRB(0, 21, 0, 21),
        child: Image.asset(
          'assets/characters/research_step_2_little.png',
          width: 172,
          height: 172,
        ),
      ),
    ],
  );
}

Widget cardLosLevel_3(BuildContext context) {
  return Column(
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff374151),
          ),
          children: [
            TextSpan(
              text: '20~30%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '까지도 괜찮아요"'),
          ],
        ),
      ),

      Container(
        margin: EdgeInsets.fromLTRB(0, 21, 0, 21),
        child: Image.asset(
          'assets/characters/research_step_2_2030p.png',
          width: 172,
          height: 172,
        ),
      ),
    ],
  );
}

Widget cardLosLevel_4(BuildContext context) {
  return Column(
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xff374151),
          ),
          children: [
            TextSpan(
              text: '절반 이상 손실',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '도 담당 가능해요"'),
          ],
        ),
      ),

      Container(
        margin: EdgeInsets.fromLTRB(0, 21, 0, 21),
        child: Image.asset(
          'assets/characters/research_step_2_crazy.png',
          width: 172,
          height: 172,
        ),
      ),
    ],
  );
}
