import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_grow/model/data_lists.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/api_view_model.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class LoadingEmotionPage extends StatefulHookConsumerWidget {
  const LoadingEmotionPage({super.key});

  @override
  ConsumerState<LoadingEmotionPage> createState() => _LoadingEmotionPageState();
}

class _LoadingEmotionPageState extends ConsumerState<LoadingEmotionPage> {
  Timer? _timer;
  int i = 0;

  Future loading() async {
    // 투자 성향 분석 로딩 대체 timer

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      setState(() {
        i = (i + 1) % 3;
      });
    });

    Future.delayed(Duration(seconds: 3), () async {
      final authState = await ref.read(authViewModelProvider.notifier);
      final surveyResult = await ref.read(surveyViewModelProvider.notifier);

      final int selectedIndexStep1 = ref.read(researchResultStep1Provider);
      final int selectedIndexStep2 = ref.read(researchResultStep2Provider);
      final List<bool> selectedIndexStep3 = ref.read(
        researchResultStep3Provider,
      );
      final double selectedIndexStep4 = ref.read(researchResultStep4Provider);
      final String? resultOfStep5_goal = ref.read(
        researchResultStep5_goalProvider,
      );
      final String? resultOfStep5_money = ref.read(
        researchResultStep5_moneyProvider,
      );

      await surveyResult.completeSurvey(
        investmentMethod: selectedIndexStep1,
        lossTolerance: selectedIndexStep2,
        preferredInvestmentTypes: selectedIndexStep3,
        investmentPeriod: selectedIndexStep4.round(),
        investmentGoal: resultOfStep5_goal ?? '',
        targetAmount:
            int.tryParse(resultOfStep5_money!.replaceAll(',', '')) ?? 0,
      );

      RiskLevel type = await ref
          .read(surveyViewModelProvider.notifier)
          .getRiskLevel();

      await authState.modifyUserType(type);
      if (mounted) {
        GoRouter.of(context).go('/post_test_result');
      }

      _timer?.cancel();
    });

    /**final authState = ref.watch(authViewModelProvider);

      
      final user = UserModel(
        id: authState.user?.id,
        nickname: authState.user?.nickname,
        email: authState.user?.email,
        profile_url: authState.user?.profile_url,
        goal: authState.user?.goal,
        goal_money: authState.user?.goal_money,
        goal_period: authState.user?.goal_period,
        research_completed: authState.user?.research_completed,
        type: type,
      );

      await SecureStorageManager.saveData(
        'AUTH_STATE',
        AuthState(status: authState.status, user: user).toRawJson() ??
            AuthState(
              status: AuthStatus.unauthenticated,
              user: null,
              errorMessage: null,
            ).toRawJson()!,
      );
 */

    //GoRouter.of(context).go('/loading_policy');

    //성향 분류 후 데이터 캐싱 필요
  }

  @override
  void initState() {
    super.initState();

    loading();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authViewModelProvider).user;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0fa564), Color(0xff3cba92)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 180.h, 0, 0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xfffcf7ec),
                ),
                children: [
                  TextSpan(
                    text: user?.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' 님의 \n성향을 분석중입니다'),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(0, 40.h, 0, 0),
            child: Image.asset(
              'assets/characters/onboarding_loading${i + 1}.png',
              width: 162.w,
              height: 243.h,
            ),
          ),
        ],
      ),
    );
  }
}
