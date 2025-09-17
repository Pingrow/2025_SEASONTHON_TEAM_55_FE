import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/pages/main/chat_bot.dart';
import 'package:pin_grow/pages/main/goal_modifying.dart';
import 'package:pin_grow/pages/main/home_page.dart';
import 'package:pin_grow/pages/main/ipo_page.dart';
import 'package:pin_grow/pages/main/login_popup.dart';
import 'package:pin_grow/pages/main/policy_list.dart';
import 'package:pin_grow/pages/main/product_list.dart';
import 'package:pin_grow/pages/main/reward.dart';
import 'package:pin_grow/pages/main/special_products.dart';
import 'package:pin_grow/pages/onboarding/loading_emotion.dart';
import 'package:pin_grow/pages/onboarding/loading_policy.dart';
import 'package:pin_grow/pages/onboarding/post_test_result.dart';
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
        path: "/post_test_result",
        name: 'post_test_result_page',
        builder: (context, state) => const PostTestResultPage(),
      ),

      GoRoute(
        path: "/home",
        name: 'home_page',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: "goal_modify",
            name: 'goal_modify',
            pageBuilder: (context, state) =>
                DialogPage(builder: (_) => GoalModifyingPage()),
          ),

          GoRoute(
            path: "portfolio_login_popup",
            name: 'portfolio_login_popup',
            pageBuilder: (context, state) =>
                DialogPage(builder: (_) => PortfolioLoginPopup()),
          ),
        ],
      ),

      /**
       * 
      GoRoute(
        path: "/profile",
        name: 'profile_page',
        builder: (context, state) => const ProfilePage(),
        routes: [
          
        ],
      ),
       */
      GoRoute(
        path: "/policy_list",
        name: 'policy_list',
        builder: (context, state) => const PolicyListPage(),
        routes: [
          GoRoute(
            path: "policy_login_popup",
            name: 'policy_login_popup',
            pageBuilder: (context, state) =>
                DialogPage(builder: (_) => PolicyLoinPopup()),
          ),
        ],
      ),

      GoRoute(
        path: "/product_list",
        name: 'product_list',
        builder: (context, state) => const ProductListPage(),
        routes: [
          GoRoute(
            path: "product_login_popup",
            name: 'product_login_popup',
            pageBuilder: (context, state) =>
                DialogPage(builder: (_) => ProductLoinPopup()),
          ),
        ],
      ),

      GoRoute(
        path: "/chat_bot",
        name: 'chat_bot',
        pageBuilder: (context, state) =>
            DialogPage(builder: (_) => ChatBotPage()),
      ),

      GoRoute(
        path: "/reward",
        name: 'reward',
        builder: (context, state) => RewardPage(),
      ),

      GoRoute(
        path: "/special",
        name: 'special',
        builder: (context, state) => SpecialProduct(),
      ),

      GoRoute(
        path: "/special_web_view",
        name: 'special_web_view',
        builder: (context, state) =>
            SpecialProductWebView(section: state.extra.toString()),
      ),

      GoRoute(
        path: "/ipo",
        name: 'ipo',
        builder: (context, state) => IPOPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? _lastPressedAt;

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
              padding: EdgeInsets.fromLTRB(10, 5, 5, 10),
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

class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
    context: context,
    settings: this,
    builder: builder,
    anchorPoint: anchorPoint,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    themes: themes,
  );
}
