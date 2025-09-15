import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';

class ResearchPageStep4 extends StatefulHookConsumerWidget {
  const ResearchPageStep4({super.key});

  @override
  ConsumerState<ResearchPageStep4> createState() => _ResearchPageStep4State();
}

class _ResearchPageStep4State extends ConsumerState<ResearchPageStep4> {
  @override
  Widget build(BuildContext context) {
    final sliderValue = ref.watch(researchResultStep4Provider);

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
                TextSpan(text: '이제 '),
                TextSpan(
                  text: '목표',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '를 설정해주세요!\n'),
                TextSpan(
                  style: TextStyle(fontSize: 23.sp),
                  children: [
                    TextSpan(text: '생각하고 있는 '),
                    TextSpan(
                      text: '목표 기간',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '은?'),
                  ],
                ),
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 40.h),
          child: Column(
            children: [
              Text(
                sliderValue < 49 ? '${sliderValue.round()}개월' : '5년 이상',
                style: TextStyle(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0fa564),
                ),
              ),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      '5년이상',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff374151),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left:
                        (MediaQuery.of(context).size.width - 2 * 20.w) *
                            ((sliderValue + 1) / 50.0) -
                        (41.w) * (sliderValue / 49.0),
                    child: Text(
                      sliderValue == 49 ? '5년이상' : '${sliderValue.round()}개월',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff374151),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(0, 15, 0, 5),
                    child: Slider(
                      divisions: 50,
                      min: 0,
                      max: 49,
                      value: sliderValue,
                      onChanged: (value) {
                        ref
                            .read(researchResultStep4Provider.notifier)
                            .setValue(value);
                      },
                    ),
                  ),

                  Positioned(
                    right: 0,
                    bottom: 10.h,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 5.h, 0.w, 5.h),
                        width: 18.r,
                        height: 18.r,
                        decoration: BoxDecoration(
                          color: Color(0xff0fa564),
                          shape: BoxShape.circle,
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
