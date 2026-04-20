abstract interface class CacheService {
  String? getAccessToken();

  String? getRefreshToken();

  String? getLocale();

  bool getPassOnboarding();

  void setAccessToken(String token);

  void setRefreshToken(String token);

  void clearTokens();

  void setLocale(String localeCode);

  void passOnboarding();
}
