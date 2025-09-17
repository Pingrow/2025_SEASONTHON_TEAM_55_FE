import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/model/data_lists.dart';
import 'package:pin_grow/model/user_model.dart';
import 'package:pin_grow/repository/api_repository.dart';
import 'package:pin_grow/service/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pin_grow/repository/auth_repository.dart';
import 'package:pin_grow/view_model/auth_state.dart';

part 'auth_view_model.g.dart';

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late final AuthRepository _repository = ref.watch(authRepositoryProvider);

  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> login() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _repository.loginWithKakao();
      await _repository.login();
    } catch (e) {
      print('[ERROR:Login] $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }

    await setAuthState(AuthStatus.authenticated, await getUser());
  }

  Future<void> logout() async {
    await _repository.kakaoLogout();
    await _repository.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  Future<void> setAuthState(AuthStatus authStatus, UserModel? user) async {
    state = state.copyWith(status: authStatus, user: user);

    await SecureStorageManager.saveData(
      'AUTH_STATE',
      AuthState(status: authStatus, user: user).toRawJson() ??
          '{status: null, user: null, errormessage: null}',
    );
  }

  /// TODO:
  /// 사용자 정보를 가지고 오는 부분 재 정의 필요
  Future<UserModel?> getUser() async {
    final kakaoUser = await UserApi.instance.me();

    final preference = await ref.read(apiRepositoryProvider).fetchPreference();

    RiskLevel? type = state.user?.type;
    String? goal = state.user?.goal;
    int? goal_money = state.user?.goal_money;
    int? goal_period = state.user?.goal_period;

    if (preference['completed']) {
      type =
          RiskLevel.values[riskLevelKeys.indexOf(preference['riskLevel']) + 1];
      goal = preference['investmentGoal'];
      goal_money = preference['targetAmount'].round();
      goal_period = preference['investmentPeriod'];
    }

    final user = UserModel(
      id: kakaoUser.id,
      nickname: kakaoUser.kakaoAccount!.profile!.nickname!,
      email: kakaoUser.kakaoAccount!.email,
      profile_url: kakaoUser.kakaoAccount!.profile!.profileImageUrl,
      type: type,
      goal: goal,
      goal_money: goal_money,
      goal_period: goal_period,
      research_completed: preference['completed'],
    );

    return user;
  }

  Future<AuthState?> getUserFromSecureStorage() async {
    final authState = AuthState.fromRawJson(
      await SecureStorageManager.readData('AUTH_STATE'),
    );

    state = state.copyWith(status: authState.status, user: authState.user);
    return authState;
  }

  Future<void> modifyUserType(RiskLevel type) async {
    final authState = AuthState.fromRawJson(
      await SecureStorageManager.readData('AUTH_STATE'),
    );

    print(authState.user?.goal);

    final user = UserModel(
      id: state.user?.id,
      nickname: state.user?.nickname,
      email: state.user?.email,
      profile_url: state.user?.profile_url,
      type: type,
      goal: authState.user?.goal,
      goal_money: authState.user?.goal_money,
      goal_period: authState.user?.goal_period,
      research_completed: authState.user?.research_completed,
    );

    state = state.copyWith(status: state.status, user: user);
  }
}
