abstract interface class CacheService {
  String? getAccessToken();

  String? getRefreshToken();

  String? getLocale();

  bool getPassOnboarding();

  Future<void> setAccessToken(String token);

  Future<void> setRefreshToken(String token);

  Future<void> clearTokens();

  void setLocale(String localeCode);

  void passOnboarding();
}
