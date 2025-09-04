import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 입력된 내용이 없으면 그대로 반환
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 1. 쉼표를 제외한 숫자만 추출
    final cleanText = newValue.text.replaceAll(',', '');

    // 2. intl 패키지를 사용하여 3자리마다 쉼표 추가
    final formatter = NumberFormat('#,###');
    final formattedText = formatter.format(int.parse(cleanText));

    // 3. 커서 위치를 올바르게 조정하여 반환
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class ResearchPageStep5 extends StatefulHookConsumerWidget {
  const ResearchPageStep5({super.key});

  @override
  ConsumerState<ResearchPageStep5> createState() => _ResearchPageStep5State();
}

class _ResearchPageStep5State extends ConsumerState<ResearchPageStep5> {
  final GlobalKey _goalFormkey = GlobalKey<FormState>();
  final GlobalKey _moneyFormkey = GlobalKey<FormState>();

  final TextEditingController goalFormCntlr = TextEditingController();
  final TextEditingController moneyFormCntlr = TextEditingController();

  bool goalValidation = false;
  bool moneyVaidation = false;

  @override
  void initState() {
    super.initState();
    goalFormCntlr.addListener(_validate);
    moneyFormCntlr.addListener(_validate);
  }

  @override
  void dispose() {
    super.dispose();
    goalFormCntlr.removeListener(_validate);
    moneyFormCntlr.removeListener(_validate);

    goalFormCntlr.dispose();
    moneyFormCntlr.dispose();
  }

  void _validate() {
    // ref.read로 notifier의 메소드만 호출 (UI 리빌드 X)
    // .notifier를 붙여 StateNotifier 인스턴스에 접근
    ref
        .read(researchResultStep5Provider.notifier)
        .validateInputs(goalFormCntlr.text, moneyFormCntlr.text);
  }

  @override
  Widget build(BuildContext context) {
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
                TextSpan(text: '마지막 질문이에요!\n'),

                TextSpan(
                  style: TextStyle(fontSize: 23.sp),
                  children: [
                    TextSpan(
                      text: '목표',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '와 '),
                    TextSpan(
                      text: '필요 금액',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '을 입력해주세요.'),
                  ],
                ),
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
          child: Column(
            children: [
              Form(
                key: _goalFormkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0),
                        child: Text(
                          '목표',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff7F7F7F),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: goalFormCntlr,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff0FA564),
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff0FA564),
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 165, 15, 15),
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 165, 15, 15),
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),

                          hintText: 'ex) 유럽여행, 전세 자금, 학자금 상환 등',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff0FA564),
                          ),

                          errorStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 165, 15, 15),
                          ),

                          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        ),

                        cursorColor: Color(0xff374151),

                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff374151),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '목표를 입력해주세요.';
                          }
                          return null;
                        },

                        onChanged: (value) {
                          ref
                              .read(researchResultStep5_goalProvider.notifier)
                              .setValue(value);
                        },

                        onSaved: (value) {
                          ref
                              .read(researchResultStep5_goalProvider.notifier)
                              .setValue(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _moneyFormkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0),
                        child: Text(
                          '필요 금액',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff7F7F7F),
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Text(
                              '원',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                            ),
                          ),

                          TextFormField(
                            controller: moneyFormCntlr,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0FA564),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0FA564),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 165, 15, 15),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 165, 15, 15),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),

                              hintText: '금액 입력',
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff0FA564),
                              ),

                              contentPadding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                            ),

                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff374151),
                            ),

                            cursorColor: Color(0xff374151),

                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              ThousandsSeparatorInputFormatter(),
                            ],

                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value.replaceAll(',', '')) ==
                                      null ||
                                  int.tryParse(value.replaceAll(',', ''))! <=
                                      0) {
                                return '금액을 입력해주세요.';
                              }
                              return null;
                            },

                            onChanged: (value) {
                              if (value.characters.length > 24) {
                                moneyFormCntlr.text = value.characters
                                    .take(24)
                                    .toString();
                              }

                              ref
                                  .read(
                                    researchResultStep5_moneyProvider.notifier,
                                  )
                                  .setValue(value);
                            },

                            onSaved: (value) {
                              if (value!.characters.length > 24) {
                                moneyFormCntlr.text = value.characters
                                    .take(24)
                                    .toString();
                              }
                              ref
                                  .read(
                                    researchResultStep5_moneyProvider.notifier,
                                  )
                                  .setValue(value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
