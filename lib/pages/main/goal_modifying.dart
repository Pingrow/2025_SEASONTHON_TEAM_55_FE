import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/pages/onboarding/research_page_step5.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class GoalModifyingPage extends StatefulHookConsumerWidget {
  const GoalModifyingPage({super.key});

  @override
  ConsumerState<GoalModifyingPage> createState() => _GoalModifyingPageState();
}

class _GoalModifyingPageState extends ConsumerState<GoalModifyingPage> {
  late final authState = ref.read(authViewModelProvider);

  final GlobalKey _goalFormkey = GlobalKey<FormState>();
  final GlobalKey _goalMoneyFormkey = GlobalKey<FormState>();
  final GlobalKey _currentMoneyFormkey = GlobalKey<FormState>();

  final TextEditingController goalFormCntlr = TextEditingController();
  final TextEditingController moneyFormCntlr = TextEditingController();
  final TextEditingController currentMoneyFormCntlr = TextEditingController();

  @override
  void initState() {
    super.initState();

    final authState = ref.read(authViewModelProvider);
    if (authState.user?.research_completed ?? false) {
      ref.read(researchResultStep4Provider.notifier).setValue(0.0);
    }
  }

  @override
  void dispose() {
    goalFormCntlr.dispose();
    moneyFormCntlr.dispose();
    currentMoneyFormCntlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sliderValue = ref.watch(researchResultStep4Provider);

    return Scaffold(
      backgroundColor: Color(0x00000000),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          0,
          MediaQuery.of(context).padding.bottom,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GestureDetector(
              onTap: () {
                GoRouter.of(context).pop();
              },
              child: Container(color: Colors.transparent),
            ),

            Container(
              width: 385.w,
              height: 521.h,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 53.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Color(0xffC3C3C3),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '목표',
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff0CA361),
                                ),
                              ),
                              TextSpan(
                                text: ' 수정하기',
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff374151),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Form(
                          key: _goalFormkey,
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(
                                    5,
                                    0,
                                    5,
                                    0,
                                  ),
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
                                        strokeAlign:
                                            BorderSide.strokeAlignInside,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff0FA564),
                                        strokeAlign:
                                            BorderSide.strokeAlignInside,
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 165, 15, 15),
                                        strokeAlign:
                                            BorderSide.strokeAlignInside,
                                      ),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 165, 15, 15),
                                        strokeAlign:
                                            BorderSide.strokeAlignInside,
                                      ),
                                    ),

                                    hintText: authState.user?.goal ?? '',
                                    hintStyle: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff818284),
                                    ),

                                    errorStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 165, 15, 15),
                                    ),

                                    contentPadding: EdgeInsets.fromLTRB(
                                      5,
                                      0,
                                      5,
                                      0,
                                    ),
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
                                        .read(
                                          researchResultStep5_goalProvider
                                              .notifier,
                                        )
                                        .setValue(value);
                                  },

                                  onSaved: (value) {
                                    ref
                                        .read(
                                          researchResultStep5_goalProvider
                                              .notifier,
                                        )
                                        .setValue(value);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Form(
                          key: _goalMoneyFormkey,
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(
                                    5,
                                    0,
                                    5,
                                    0,
                                  ),
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
                                            strokeAlign:
                                                BorderSide.strokeAlignInside,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff0FA564),
                                            strokeAlign:
                                                BorderSide.strokeAlignInside,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                              255,
                                              165,
                                              15,
                                              15,
                                            ),
                                            strokeAlign:
                                                BorderSide.strokeAlignInside,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                  255,
                                                  165,
                                                  15,
                                                  15,
                                                ),
                                                strokeAlign: BorderSide
                                                    .strokeAlignInside,
                                              ),
                                            ),

                                        hintText: NumberFormat.decimalPattern()
                                            .format(
                                              authState.user?.goal_money ?? 0,
                                            ),
                                        hintStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff818284),
                                        ),

                                        contentPadding: EdgeInsets.fromLTRB(
                                          5,
                                          0,
                                          15,
                                          0,
                                        ),
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
                                            int.tryParse(
                                                  value.replaceAll(',', ''),
                                                ) ==
                                                null ||
                                            int.tryParse(
                                                  value.replaceAll(',', ''),
                                                )! <=
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
                                              researchResultStep5_moneyProvider
                                                  .notifier,
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
                                              researchResultStep5_moneyProvider
                                                  .notifier,
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0),
                          child: Text(
                            '목표 기간',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff7F7F7F),
                            ),
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
                                  (350.w - 25.w) * (sliderValue / 49.0) - 22.w,
                              child: Text(
                                sliderValue == 49
                                    ? '5년이상'
                                    : '${sliderValue.round()}개월',
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
                                divisions: 49,
                                min: 0,
                                max: 49,
                                value: sliderValue,
                                onChanged: (value) {
                                  ref
                                      .read(
                                        researchResultStep4Provider.notifier,
                                      )
                                      .setValue(value);
                                },
                              ),
                            ),

                            Positioned(
                              right: 0,
                              bottom: 10,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: 18.r,
                                height: 18.r,
                                decoration: BoxDecoration(
                                  color: Color(0xff0fa564),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _currentMoneyFormkey,
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0),
                            child: Text(
                              '현재까지 모은 금액',
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
                                controller: currentMoneyFormCntlr,
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

                                  hintText: NumberFormat.decimalPattern()
                                      .format(authState.user?.saved_money ?? 0),
                                  hintStyle: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff818284),
                                  ),

                                  contentPadding: EdgeInsets.fromLTRB(
                                    5,
                                    0,
                                    15,
                                    0,
                                  ),
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
                                      int.tryParse(
                                            value.replaceAll(',', ''),
                                          )! <=
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
                                      .read(currentSavedMoneyProvider.notifier)
                                      .setValue(value);
                                },

                                onSaved: (value) {
                                  if (value!.characters.length > 24) {
                                    moneyFormCntlr.text = value.characters
                                        .take(24)
                                        .toString();
                                  }
                                  ref
                                      .read(currentSavedMoneyProvider.notifier)
                                      .setValue(value);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      final goal_period = sliderValue.round();
                      print(sliderValue);
                      ref
                          .read(researchResultStep4Provider.notifier)
                          .setValue(sliderValue);

                      final goal = goalFormCntlr.text;
                      ref
                          .read(researchResultStep5_goalProvider.notifier)
                          .setValue(goal);

                      final goalMoney = moneyFormCntlr.text.replaceAll(',', '');
                      ref
                          .read(researchResultStep5_moneyProvider.notifier)
                          .setValue(goalMoney);

                      final savedMoney = currentMoneyFormCntlr.text;
                      ref
                          .read(currentSavedMoneyProvider.notifier)
                          .setValue(savedMoney);

                      final authState = ref.read(
                        authViewModelProvider.notifier,
                      );
                      final state = ref.read(authViewModelProvider);
                      authState.setAuthState(
                        state.status,
                        UserModel(
                          id: state.user?.id,
                          nickname: state.user?.nickname,
                          email: state.user?.email,
                          profile_url: state.user?.profile_url,
                          type: state.user?.type,
                          goal: goal.isEmpty ? state.user?.goal : goal,
                          goal_money: goalMoney.isEmpty
                              ? state.user?.goal_money
                              : int.tryParse(goalMoney.replaceAll(',', '')),
                          goal_period: goal_period == 0
                              ? state.user?.goal_period
                              : goal_period,
                          saved_money: savedMoney.isEmpty
                              ? state.user?.saved_money
                              : int.tryParse(savedMoney.replaceAll(',', '')),
                          research_completed:
                              state.user?.research_completed ?? false,
                        ),
                      );

                      GoRouter.of(context).pop();
                    },
                    child: Container(
                      width: 347.w,
                      height: 52.h,
                      margin: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                      decoration: BoxDecoration(
                        color: Color(0xff0fa564),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '수정 완료',
                        style: TextStyle(
                          color: Color(0xfffcf7e2),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pop();
                    },
                    child: Text(
                      '닫기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7D7D7D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
