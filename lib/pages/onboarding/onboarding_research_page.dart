import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/providers/onboarding_providers.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:pin_grow/view_model/auth_state.dart';
import 'package:pin_grow/view_model/auth_view_model.dart';

class OnboardingResearchPage extends StatefulHookConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const OnboardingResearchPage({super.key, required this.navigationShell});

  @override
  ConsumerState<OnboardingResearchPage> createState() =>
      _OnboardingResearchPageState();
}

const Map<int, String> INDEX_ENDPOINT_MAPPER = {
  1: '/step1',
  2: '/step2',
  3: '/step3',
  4: '/step4',
  5: '/step5',
};

class _OnboardingResearchPageState
    extends ConsumerState<OnboardingResearchPage> {
  int maxStep = 5;

  @override
  Widget build(BuildContext context) {
    int currentStep = ref.watch(selectedIndexProvider);
    final int selectedIndexStep1 = ref.watch(researchResultStep1Provider);
    final int selectedIndexStep2 = ref.watch(researchResultStep2Provider);
    final List<bool> selectedIndexStep3 = ref.watch(
      researchResultStep3Provider,
    );
    final double selectedIndexStep4 = ref.watch(researchResultStep4Provider);
    final bool resultOfStep5 = ref.watch(researchResultStep5Provider);
    final String? resultOfStep5_goal = ref.watch(
      researchResultStep5_goalProvider,
    );
    final String? resultOfStep5_money = ref.watch(
      researchResultStep5_moneyProvider,
    );

    final authState = ref.read(authViewModelProvider);

    void initNavigationIndex(BuildContext context) {
      final routerState = GoRouterState.of(context);
      late int index;
      for (final entry in INDEX_ENDPOINT_MAPPER.entries) {
        if (routerState.fullPath!.startsWith(entry.value)) {
          index = entry.key;
        }
      }
      setState(() => currentStep = index);
    }

    void move(int index) {
      final hasAlreadyOnBranch = index == widget.navigationShell.currentIndex;

      if (hasAlreadyOnBranch) {
        context.go(INDEX_ENDPOINT_MAPPER[index]!);
      } else {
        widget.navigationShell.goBranch(index);
      }
    }

    bool isSelected(int currentStep) {
      bool result = false;

      switch (currentStep) {
        case 1:
          result = selectedIndexStep1 != -1;
          //print(result);
          break;
        case 2:
          result = selectedIndexStep2 != -1;
          break;
        case 3:
          result =
              selectedIndexStep3[0] ||
              selectedIndexStep3[1] ||
              selectedIndexStep3[2] ||
              selectedIndexStep3[3];
          break;
        case 4:
          result = selectedIndexStep4 != -1;
          break;
        case 5:
          result = resultOfStep5;
          break;
      }

      return result;
    }

    initNavigationIndex(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(color: Color(0xffffffff)),
      child: Column(
        children: [
          Container(
            width: 338.w,
            height: 39.h,
            margin: EdgeInsets.fromLTRB(0, 50, 0, 30),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      if (currentStep > 0) {
                        move(currentStep - 1);
                      }
                    },
                    child: Image.asset(
                      'assets/icons/back.png',
                      width: 10.w,
                      height: 16.h,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$currentStep / $maxStep',
                        style: GoogleFonts.aBeeZee(fontSize: 12.sp),
                      ),

                      SizedBox(height: 8.h),

                      LinearProgressBar(
                        maxSteps: maxStep,
                        progressType: LinearProgressBar
                            .progressTypeLinear, // Use Linear progress
                        currentStep: currentStep,
                        progressColor: Color(0xff0ba360),
                        backgroundColor: Color(0xffe5e7eb),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 8.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: widget.navigationShell),

          Visibility(
            visible: isSelected(currentStep),
            child: InkWell(
              onTap: () async {
                if (currentStep == 1) {
                  ref.read(selectedIndexProvider.notifier).setIndex(2);
                  print('$selectedIndexStep1');
                  move(currentStep);
                } else if (currentStep == 2) {
                  ref.read(selectedIndexProvider.notifier).setIndex(3);
                  print('$selectedIndexStep2');
                  move(currentStep);
                } else if (currentStep == 3) {
                  ref.read(selectedIndexProvider.notifier).setIndex(4);
                  print('$selectedIndexStep3');
                  move(currentStep);
                } else if (currentStep == 4) {
                  ref.read(selectedIndexProvider.notifier).setIndex(5);
                  print('$selectedIndexStep4');
                  move(currentStep);
                } else if (currentStep == 5) {
                  ref.read(selectedIndexProvider.notifier).setIndex(200);
                  print('$resultOfStep5_goal , $resultOfStep5_money');

                  final user = UserModel(
                    id: authState.user?.id,
                    nickname: authState.user?.nickname,
                    email: authState.user?.email,
                    profile_url: authState.user?.profile_url,
                    goal: resultOfStep5_goal,
                    goal_money: int.tryParse(
                      resultOfStep5_money!.replaceAll(',', ''),
                    ),
                    goal_period: selectedIndexStep4.round(),
                    research_completed: true,
                  );

                  await SecureStorageManager.saveData(
                    'AUTH_STATE',
                    AuthState(
                          status: authState.status,
                          user: user,
                        ).toRawJson() ??
                        AuthState(
                          status: AuthStatus.unauthenticated,
                          user: null,
                          errorMessage: null,
                        ).toRawJson()!,
                  );

                  //GoRouter.of(context).go('/home');
                  GoRouter.of(context).go('/loading_emotion');
                }
              },
              child: Container(
                width: 347.w,
                height: 52.h,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 60),
                decoration: BoxDecoration(
                  color: Color(0xff0fa564),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '다음',
                  style: TextStyle(
                    color: Color(0xfffcf7e2),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
