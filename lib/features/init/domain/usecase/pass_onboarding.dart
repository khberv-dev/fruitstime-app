import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';

final passOnboardingProvider = Provider((ref) => PassOnboarding(ref.read(cacheProvider)));

class PassOnboarding {
  final CacheService _cacheService;

  PassOnboarding(this._cacheService);

  void call() {
    _cacheService.passOnboarding();
  }
}
