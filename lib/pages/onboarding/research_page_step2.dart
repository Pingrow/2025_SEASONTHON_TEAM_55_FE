import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/pages/onboarding/card_loss.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ResearchPageStep2 extends StatefulHookConsumerWidget {
  const ResearchPageStep2({super.key});

  @override
  ConsumerState<ResearchPageStep2> createState() => _ResearchPageStep2State();
}

class _ResearchPageStep2State extends ConsumerState<ResearchPageStep2> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(researchResultStep2Provider);

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
                TextSpan(text: '만약 '),
                TextSpan(
                  text: '손실',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '이 발생했을 때\n얼마나 감내할 수 있나요?'),
              ],
            ),
          ),
        ),

        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 261.h,

                child: CarouselSlider(
                  items: [
                    cardLosLevel_1(context),
                    cardLosLevel_2(context),
                    cardLosLevel_3(context),
                    cardLosLevel_4(context),
                  ],
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    autoPlay: false,
                    aspectRatio: 1,
                    viewportFraction: 1,
                    initialPage: selectedIndex,
                    clipBehavior: Clip.none,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      ref
                          .read(researchResultStep2Provider.notifier)
                          .setIndex(index);
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: selectedIndex > 0,
                    child: InkWell(
                      onTap: () {
                        _carouselController.animateToPage(selectedIndex - 1);
                        ref
                            .read(researchResultStep2Provider.notifier)
                            .setIndex(selectedIndex - 1);
                      },

                      child: Image.asset(
                        'assets/icons/left_arrow_button.png',
                        width: 30.w,
                        height: 30.w,
                      ),
                    ),
                  ),

                  SizedBox(width: 206.w, height: 261.h),

                  Visibility(
                    visible: selectedIndex < 3,
                    child: InkWell(
                      onTap: () {
                        _carouselController.animateToPage(selectedIndex + 1);
                        ref
                            .read(researchResultStep2Provider.notifier)
                            .setIndex(selectedIndex + 1);
                      },
                      child: Image.asset(
                        'assets/icons/right_arrow_button.png',
                        width: 30.w,
                        height: 30.w,
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
