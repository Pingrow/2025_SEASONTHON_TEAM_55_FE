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

    /**final authState = await getUser();
    
    final url = Uri.http('3.27.44.246:8080/', '/api/v1/auth/kakao');
    final body = {
      'code' : OAuthToken.fromResponse(response)
    } */
    //await setAuthState(AuthStatus.authenticated, authState?.user);
  }

  Future<void> kakaoLogout() async {
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

    await SecureStorageManager.saveData('AUTH_STATUS', authStatus.toString());
    if (user != null) {
      await SecureStorageManager.saveData(
        'CURRENT_USER_ID',
        user.id.toString(),
      );
      await SecureStorageManager.saveData(
        'CURRENT_USER_NAME',
        user.nickname.toString(),
      );
      await SecureStorageManager.saveData(
        'CURRENT_USER_EMAIL',
        user.email.toString(),
      );
      await SecureStorageManager.saveData(
        'CURRENT_USER_PROFILE_IMAGE',
        user.profile_url.toString(),
      );
      await SecureStorageManager.saveData(
        'CURRENT_USER_TYPE',
        user.type.toString(),
      );
      await SecureStorageManager.saveData(
        'CURRENT_USER_GOAL',
        user.goal.toString(),
      );
      await SecureStorageManager.saveData(
        'CURRENT_USER_GOAL_MONEY',
        user.goal_money.toString(),
      );
      await SecureStorageManager.saveData(
        'CURRENT_USER_GOAL_PERIOD',
        user.goal_period.toString(),
      );
      await SecureStorageManager.saveData(
        'RESEARCH_COMPLETE_BOOL',
        user.research_completed.toString(),
      );
    }
  }

  Future<AuthState?> getUser() async {
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
    return AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<AuthState?> getUserFromSecureStorage() async {
    final authState = AuthState.fromRawJson(
      await SecureStorageManager.readData('AUTH_STATE'),
    );

    state = state.copyWith(status: authState.status, user: authState.user);
    return authState;
  }

  Future<void> modifyUserType(UserType type) async {
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
