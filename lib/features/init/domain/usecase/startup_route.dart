import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:fruitstime/features/app/presentation/ui/app_screen.dart';
import 'package:fruitstime/features/init/presentation/ui/onboarding_screen.dart';
import 'package:fruitstime/features/init/presentation/ui/select_locale_screen.dart';

final startupRouteProvider = Provider((ref) => StartupRoute(ref.read(cacheProvider)));

class StartupRoute {
  final CacheService _cacheService;

  StartupRoute(this._cacheService);

  String call() {
    if (_cacheService.getLocale() == null) return SelectLocaleScreen.path;

    if (!_cacheService.getPassOnboarding()) return OnboardingScreen.path;

    return AppScreen.path;
  }
}
