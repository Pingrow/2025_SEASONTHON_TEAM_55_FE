import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';

class ResearchPageStep1 extends StatefulHookConsumerWidget {
  const ResearchPageStep1({super.key});

  @override
  ConsumerState<ResearchPageStep1> createState() => _ResearchPageStep1State();
}

class _ResearchPageStep1State extends ConsumerState<ResearchPageStep1> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(researchResultStep1Provider);

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
                TextSpan(text: '안녕하세요, '),
                TextSpan(
                  text: '핀그로우',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '입니다 !'),
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/icons/comment_box.svg',
                    width: 251,
                    height: 91,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xfffcf7e2),
                        ),
                        children: [
                          TextSpan(
                            text: '돈을 관리',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '할 때 \n어떤 방식을 '),
                          TextSpan(
                            text: '선호',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '하나요?'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Image.asset(
                'assets/characters/research_step_1.png',
                width: 75,
                height: 95,
              ),
            ],
          ),
        ),

        InkWell(
          onTap: () {
            if (selectedIndex == 0) {
              ref.read(researchResultStep1Provider.notifier).setIndex(-1);
            } else {
              ref.read(researchResultStep1Provider.notifier).setIndex(0);
            }
          },
          child: Container(
            width: 338.w,
            height: 60.h,
            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
            decoration: BoxDecoration(
              color: Color(selectedIndex == 0 ? 0x330fa564 : 0xfff4f4f4),
              border: Border.all(
                color: Color(selectedIndex == 0 ? 0xff0fa564 : 0xfff4f4f4),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Color(0xff374151)),
                children: [
                  TextSpan(
                    text: '한 번',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에, '),
                  TextSpan(
                    text: '한 곳',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에서 관리하고 싶어요'),
                ],
              ),
            ),
          ),
        ),

        InkWell(
          onTap: () {
            if (selectedIndex == 1) {
              ref.read(researchResultStep1Provider.notifier).setIndex(-1);
            } else {
              ref.read(researchResultStep1Provider.notifier).setIndex(1);
            }
          },
          child: Container(
            width: 338.w,
            height: 60.h,
            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
            decoration: BoxDecoration(
              color: Color(selectedIndex == 1 ? 0x330fa564 : 0xfff4f4f4),
              border: Border.all(
                color: Color(selectedIndex == 1 ? 0xff0fa564 : 0xfff4f4f4),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Color(0xff374151)),
                children: [
                  TextSpan(
                    text: '한 번',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에, '),
                  TextSpan(
                    text: '여러 곳에 나눠',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' 넣고 싶어요'),
                ],
              ),
            ),
          ),
        ),

        InkWell(
          onTap: () {
            if (selectedIndex == 2) {
              ref.read(researchResultStep1Provider.notifier).setIndex(-1);
            } else {
              ref.read(researchResultStep1Provider.notifier).setIndex(2);
            }
          },
          child: Container(
            width: 338.w,
            height: 60.h,
            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
            decoration: BoxDecoration(
              color: Color(selectedIndex == 2 ? 0x330fa564 : 0xfff4f4f4),
              border: Border.all(
                color: Color(selectedIndex == 2 ? 0xff0fa564 : 0xfff4f4f4),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Color(0xff374151)),
                children: [
                  TextSpan(
                    text: '여러 번',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에 결쳐서 넣고 싶고, '),
                  TextSpan(
                    text: '한 곳',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에서 관리하고 싶어요'),
                ],
              ),
            ),
          ),
        ),

        InkWell(
          onTap: () {
            if (selectedIndex == 3) {
              ref.read(researchResultStep1Provider.notifier).setIndex(-1);
            } else {
              ref.read(researchResultStep1Provider.notifier).setIndex(3);
            }
          },
          child: Container(
            width: 338.w,
            height: 60.h,
            margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
            decoration: BoxDecoration(
              color: Color(selectedIndex == 3 ? 0x330fa564 : 0xfff4f4f4),
              border: Border.all(
                color: Color(selectedIndex == 3 ? 0xff0fa564 : 0xfff4f4f4),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Color(0xff374151)),
                children: [
                  TextSpan(
                    text: '여러 번',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에 결쳐서 넣고 싶고, '),
                  TextSpan(
                    text: '여러 곳에 나눠',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' 넣고 싶어요'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
