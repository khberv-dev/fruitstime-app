import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cacheProvider = Provider<CacheService>((_) => throw UnimplementedError());

class CacheServiceImpl implements CacheService {
  final SharedPreferences _sharedPreferences;

  CacheServiceImpl(this._sharedPreferences);

  @override
  String? getAccessToken() {
    return _sharedPreferences.getString(accessTokenKey);
  }

  @override
  String? getRefreshToken() {
    return _sharedPreferences.getString(refreshTokenKey);
  }

  @override
  Future<void> setAccessToken(String token) async {
    await _sharedPreferences.setString(accessTokenKey, token);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await _sharedPreferences.setString(refreshTokenKey, token);
  }

  @override
  String? getLocale() {
    return _sharedPreferences.getString(localeKey);
  }

  @override
  void setLocale(String localeCode) {
    _sharedPreferences.setString(localeKey, localeCode);
  }

  @override
  bool getPassOnboarding() {
    return _sharedPreferences.getBool(passOnboardingKey) ?? false;
  }

  @override
  void passOnboarding() {
    _sharedPreferences.setBool(passOnboardingKey, true);
  }

  @override
  Future<void> clearTokens() async {
    await _sharedPreferences.remove(accessTokenKey);
    await _sharedPreferences.remove(refreshTokenKey);
  }
}
