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
    setAuthState(state.status, state.user);
  }

  Future<void> kakaoLogout() async {
    await _repository.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }

  void setAuthState(AuthStatus authStatus, UserModel? user) {
    state = state.copyWith(status: authStatus, user: user);

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
    }
  }

  Future<void> getUser() async {
    final kakaoUser = await UserApi.instance.me();
    final user = UserModel(
      id: kakaoUser.id,
      nickname: kakaoUser.kakaoAccount!.profile!.nickname!,
      email: kakaoUser.kakaoAccount!.email!,
      profile_url: kakaoUser.kakaoAccount!.profile!.profileImageUrl,
    );

    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }
}
