import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pin_grow/model/user_model.dart';
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

  Future<void> kakaoLogin() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _repository.loginWithKakao();
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }

    await getUser();
    await setAuthState(AuthStatus.authenticated, state.user);
  }

  Future<void> kakaoLogout() async {
    await _repository.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  Future<void> setAuthState(AuthStatus authStatus, UserModel? user) async {
    state = state.copyWith(status: authStatus, user: user);

    SecureStorageManager.saveData('AUTH_STATE', state.toRawJson() ?? '{}');

    SecureStorageManager.saveData('AUTH_STATUS', authStatus.toString());
    if (user != null) {
      SecureStorageManager.saveData('CURRENT_USER_ID', user.id.toString());
      SecureStorageManager.saveData(
        'CURRENT_USER_NAME',
        user.nickname.toString(),
      );
      SecureStorageManager.saveData(
        'CURRENT_USER_EMAIL',
        user.email.toString(),
      );
      SecureStorageManager.saveData(
        'CURRENT_USER_PROFILE_IMAGE',
        user.profile_url.toString(),
      );
      SecureStorageManager.saveData('CURRENT_USER_TYPE', user.type.toString());
      SecureStorageManager.saveData('CURRENT_USER_GOAL', user.goal.toString());
      SecureStorageManager.saveData(
        'CURRENT_USER_GOAL_MONEY',
        user.goal_money.toString(),
      );
      SecureStorageManager.saveData(
        'CURRENT_USER_GOAL_PERIOD',
        user.goal_period.toString(),
      );
      SecureStorageManager.saveData(
        'RESEARCH_COMPLETE_BOOL',
        user.research_completed.toString(),
      );
    }
  }

  Future<void> getUser() async {
    final kakaoUser = await UserApi.instance.me();
    // DB에 저장된 부가 정보들도 가져오기
    final user = UserModel(
      id: kakaoUser.id,
      nickname: kakaoUser.kakaoAccount!.profile!.nickname!,
      email: kakaoUser.kakaoAccount!.email!,
      profile_url: kakaoUser.kakaoAccount!.profile!.profileImageUrl,
      type: state.user?.type,
      goal: state.user?.goal,
      goal_money: state.user?.goal_money,
      goal_period: state.user?.goal_period,
      research_completed: state.user?.research_completed,
    );

    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }

  Future<void> fetchUserModel(UserType type) async {
    final goal_period = await SecureStorageManager.readData('GOAL_PERIOD');

    final goal = await SecureStorageManager.readData('GOAL_NAME');

    final goal_money = await SecureStorageManager.readData('GOAL_MONEY');

    final research_completed = await SecureStorageManager.readBoolData(
      'RESEARCH_COMPLETE_BOOL',
    );

    final user = UserModel(
      id: state.user?.id,
      nickname: state.user?.nickname,
      email: state.user?.email,
      profile_url: state.user?.profile_url,
      type: type,
      goal: goal,
      goal_money: int.parse(goal_money!.replaceAll(',', '')),
      goal_period: int.parse(goal_period!),
      research_completed: research_completed,
    );

    state = state.copyWith(status: state.status, user: user);
  }
}
