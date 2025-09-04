import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';

class ResearchPageStep3 extends StatefulHookConsumerWidget {
  const ResearchPageStep3({super.key});

  @override
  ConsumerState<ResearchPageStep3> createState() => _ResearchPageStep3State();
}

class _ResearchPageStep3State extends ConsumerState<ResearchPageStep3> {
  @override
  Widget build(BuildContext context) {
    final selectedState = ref.watch(researchResultStep3Provider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 66.h,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: TextStyle(fontSize: 28.sp, color: Color(0xff374151)),
              children: [
                TextSpan(
                  text: '선호하는 투자 유형',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '이 있다면 \n'),
                TextSpan(
                  text: '여러 개 ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '선택해주세요'),
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(30.w, 40.h, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  if (selectedState[0]) {
                    ref
                        .read(researchResultStep3Provider.notifier)
                        .setState(0, false);
                  } else {
                    ref
                        .read(researchResultStep3Provider.notifier)
                        .setState(0, true);
                  }
                },
                child: Container(
                  width: 245.w,
                  height: 46.h,
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  decoration: BoxDecoration(
                    color: Color(selectedState[0] ? 0x330fa564 : 0xfff4f4f4),
                    border: Border.all(
                      color: Color(selectedState[0] ? 0xff0fa564 : 0xfff4f4f4),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '예금/적금 - 원금보장, 수익률 낮음',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: selectedState[0]
                          ? FontWeight.bold
                          : FontWeight.w400,
                      color: Color(0xff374151),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (selectedState[1]) {
                    ref
                        .read(researchResultStep3Provider.notifier)
                        .setState(1, false);
                  } else {
                    ref
                        .read(researchResultStep3Provider.notifier)
                        .setState(1, true);
                  }
                },
                child: Container(
                  width: 231.w,
                  height: 46.h,
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  decoration: BoxDecoration(
                    color: Color(selectedState[1] ? 0x330fa564 : 0xfff4f4f4),
                    border: Border.all(
                      color: Color(selectedState[1] ? 0xff0fa564 : 0xfff4f4f4),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'ETF 시장에 넓게 나눠 담아 분산',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: selectedState[1]
                          ? FontWeight.bold
                          : FontWeight.w400,
                      color: Color(0xff374151),
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (selectedState[2]) {
                        ref
                            .read(researchResultStep3Provider.notifier)
                            .setState(2, false);
                      } else {
                        ref
                            .read(researchResultStep3Provider.notifier)
                            .setState(2, true);
                      }
                    },
                    child: Container(
                      width: 173.w,
                      height: 46.h,
                      margin: EdgeInsets.fromLTRB(0, 4, 4, 4),
                      decoration: BoxDecoration(
                        color: Color(
                          selectedState[2] ? 0x330fa564 : 0xfff4f4f4,
                        ),
                        border: Border.all(
                          color: Color(
                            selectedState[2] ? 0xff0fa564 : 0xfff4f4f4,
                          ),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '국채 - 손실, 변동 적음',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: selectedState[2]
                              ? FontWeight.bold
                              : FontWeight.w400,
                          color: Color(0xff374151),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (selectedState[3]) {
                        ref
                            .read(researchResultStep3Provider.notifier)
                            .setState(3, false);
                      } else {
                        ref
                            .read(researchResultStep3Provider.notifier)
                            .setState(3, true);
                      }
                    },
                    child: Container(
                      width: 137.w,
                      height: 46.h,
                      margin: EdgeInsets.fromLTRB(4, 4, 0, 4),
                      decoration: BoxDecoration(
                        color: Color(
                          selectedState[3] ? 0x330fa564 : 0xfff4f4f4,
                        ),
                        border: Border.all(
                          color: Color(
                            selectedState[3] ? 0xff0fa564 : 0xfff4f4f4,
                          ),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '펀드 - 분산 투자',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: selectedState[3]
                              ? FontWeight.bold
                              : FontWeight.w400,
                          color: Color(0xff374151),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
