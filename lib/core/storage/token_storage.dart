import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  static const _rememberKey = 'remember_email';
  static const _keepKey = 'keep_session';

  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _secure.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _secure.read(key: _tokenKey);

  Future<void> clearToken() => _secure.delete(key: _tokenKey);

  /// Whether the session should survive an app restart ("Remember me").
  Future<void> setKeepSession(bool keep) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keepKey, keep);
  }

  Future<bool> keepSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keepKey) ?? false;
  }

  Future<void> saveRememberedEmail(String? email) async {
    final prefs = await SharedPreferences.getInstance();
    if (email == null) {
      await prefs.remove(_rememberKey);
    } else {
      await prefs.setString(_rememberKey, email);
    }
  }

  Future<String?> readRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberKey);
  }
}
