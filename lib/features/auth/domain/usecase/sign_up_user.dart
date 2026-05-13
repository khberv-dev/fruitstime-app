import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:fruitstime/features/auth/data/repository/auth_repository.dart';
import 'package:fruitstime/features/auth/domain/model/register_session.dart';

final signUpUserProvider = Provider(
  (ref) => SignUpUser(ref.read(authRepositoryProvider), ref.read(cacheProvider)),
);

class SignUpUser {
  final AuthRepository _repository;
  final CacheService _cache;

  SignUpUser(this._repository, this._cache);

  Future<void> call(RegisterSession session) async {
    final data = await _repository.register(
      firstName: session.firstName,
      phoneNumber: session.phoneNumber,
      password: session.password,
      referralCode: session.referralCode,
    );

    await _cache.setAccessToken(data['accessToken']);
    await _cache.setRefreshToken(data['refreshToken']);
  }
}
