import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:fruitstime/features/auth/data/repository/auth_repository.dart';

final signInUserProvider = Provider(
  (ref) => SignInUser(ref.read(authRepositoryProvider), ref.read(cacheProvider)),
);

class SignInUser {
  final AuthRepository _repository;
  final CacheService _cache;

  SignInUser(this._repository, this._cache);

  Future<void> call({required String phoneNumber, required String password}) async {
    final data = await _repository.login(phoneNumber: phoneNumber, password: password);

    _cache.setAccessToken(data['accessToken']);
    _cache.setRefreshToken(data['refreshToken']);
  }
}
