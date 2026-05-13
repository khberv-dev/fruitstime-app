import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';

final logoutProvider = Provider((ref) => Logout(ref.read(cacheProvider)));

class Logout {
  final CacheService _cache;

  Logout(this._cache);

  Future<void> call() async {
    await _cache.clearTokens();
  }
}
