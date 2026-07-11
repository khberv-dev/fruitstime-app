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

  String? getSelectedBranchId();

  void setSelectedBranchId(String id);

  String? getSelectedAddressId();

  void setSelectedAddressId(String id);

  void clearSelectedAddressId();

  String? getSessionId();

  void setSessionId(String id);

  void clearSessionId();

  bool hasSeenPopupBanner(String id);

  void markPopupBannerSeen(String id);
}
