import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/pages/main/home_page.dart';
import 'package:pin_grow/pages/onboarding/loading_emotion.dart';
import 'package:pin_grow/pages/onboarding/loading_policy.dart';
import 'package:pin_grow/pages/onboarding/research_page_step1.dart';
import 'package:pin_grow/pages/onboarding/research_page_step2.dart';
import 'package:pin_grow/pages/onboarding/research_page_step3.dart';
import 'package:pin_grow/pages/onboarding/research_page_step4.dart';
import 'package:pin_grow/pages/onboarding/research_page_step5.dart';
import 'package:pin_grow/pages/main/signin_page.dart';
import 'package:pin_grow/pages/main/splash_page.dart';
import 'package:pin_grow/pages/onboarding/onboarding_research_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  KakaoSdk.init(nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'));

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends HookConsumerWidget {
  final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();
  //final GlobalKey<NavigatorState> _shellNavKey = GlobalKey<NavigatorState>();

  GoRouter router() => GoRouter(
    initialLocation: "/",
    navigatorKey: _rootNavKey,
    routes: [
      GoRoute(
        path: "/",
        name: 'splash_view',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: "/signIn",
        name: 'signIn_Page',
        builder: (context, state) => const SignInPage(),
      ),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavKey,
        builder: (context, state, navigationShell) =>
            OnboardingResearchPage(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/step1',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ResearchPageStep1()),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/step2',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ResearchPageStep2()),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/step3',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ResearchPageStep3()),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/step4',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ResearchPageStep4()),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/step5',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ResearchPageStep5()),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: "/loading_emotion",
        name: 'loading_emotion_page',
        builder: (context, state) => const LoadingEmotionPage(),
      ),

      GoRoute(
        path: "/loading_policy",
        name: 'loading_policy_page',
        builder: (context, state) => const LoadingPolicyPage(),
      ),

      GoRoute(
        path: "/home",
        name: 'home_page',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(402, 874), // 디자인 시안의 너비, 높이
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router(),
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xFFD9D9D9),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
            ),
            fontFamily: 'Pretendard',
            sliderTheme: SliderThemeData(
              activeTrackColor: Color(0x800ba360),
              inactiveTrackColor: Color(0xffE5E7EB),
              activeTickMarkColor: Color(0x00ffffff),
              inactiveTickMarkColor: Color(0x00ffffff),
              overlayColor: Color(0x00ffffff),
              thumbColor: Color(0xff0BA360),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 9.r),
              valueIndicatorColor: Color(0x00ffffff),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              trackHeight: 8.h,
            ),
          ),
          builder: (context, child) {
            return Scaffold(
              resizeToAvoidBottomInset: false,

              body: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: child!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
