import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthRepository {
  AuthRepository(this._client, this._storage);

  final ApiClient _client;
  final TokenStorage _storage;

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final res = await _client.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final token = _extractToken(res.data);
      if (token == null) {
        // Include the raw body so the real response shape is visible.
        throw ApiException('Unexpected server response: ${res.data}');
      }
      await _storage.saveToken(token);
      await _storage.saveRememberedEmail(rememberMe ? email : null);
      await _storage.setKeepSession(rememberMe);
    } on DioException catch (e) {
      throw ApiClient.toApiException(e);
    }
  }

  Future<String> sendResetInstructions(String email) async {
    try {
      final res = await _client.dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
      final data = res.data;
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
      return 'Reset instructions sent to your email.';
    } on DioException catch (e) {
      throw ApiClient.toApiException(e);
    }
  }

  Future<String?> rememberedEmail() => _storage.readRememberedEmail();

  /// True only for a saved session the user chose to keep; otherwise any
  /// leftover token is discarded so the login screen is shown.
  Future<bool> hasSession() async {
    final token = await _storage.readToken();
    if (token == null) return false;
    if (await _storage.keepSession()) return true;
    await _storage.clearToken();
    return false;
  }

  Future<void> logout() => _storage.clearToken();

  /// The response shape is not documented; find any string under a key that
  /// looks like a token, at any depth.
  String? _extractToken(dynamic data) {
    if (data is Map) {
      for (final e in data.entries) {
        final key = e.key.toString().toLowerCase();
        if (e.value is String &&
            (key.contains('token') || key == 'jwt') &&
            (e.value as String).isNotEmpty) {
          return e.value as String;
        }
      }
      for (final value in data.values) {
        final found = _extractToken(value);
        if (found != null) return found;
      }
    }
    return null;
  }
}
