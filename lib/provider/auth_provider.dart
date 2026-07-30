import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_canteen_shop/services/preference_service.dart';

import '../models/login_response.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart' as app_firebase;

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<LoginResponse?>>((ref) {
      return AuthNotifier(ref.read(apiServiceProvider));
    });

class AuthNotifier extends StateNotifier<AsyncValue<LoginResponse?>> {
  final ApiService api;

  AuthNotifier(this.api) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      final fcmService = app_firebase.FirebaseService();

      final fcmToken = await fcmService.getFcmToken();
        print("fcm token is $fcmToken");
      final result = await api.login(
        email: email,

        password: password,

        fcmToken: fcmToken,
      );

      await PreferenceService().saveLogin(
        token: result.token,

        userId: result.user.userId,

        username: result.user.userName,

        role: result.user.roleName,

        
      );

      state = AsyncData(result);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<String> changePasswordWallet({
    required String currentPassword,
    required String newPassword,
   
  }) async {
    final token = await PreferenceService().getToken();

    if (token == null) {
      throw Exception("Login session expired.");
    }

    return await api.changePasswordWallet(
      token: token,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword
  }) async {
    final token = await PreferenceService().getToken();

    if (token == null) {
      throw Exception("Login session expired.");
    }

    return await api.changePassword(
      token: token,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword
    );
  }

  
}
