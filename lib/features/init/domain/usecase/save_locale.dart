import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/data/cache/cache_service.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';

final saveLocaleProvider = Provider((ref) => SaveLocale(ref.read(cacheProvider)));

class SaveLocale {
  final CacheService _cacheService;

  SaveLocale(this._cacheService);

  void call(String localeCode) {
    _cacheService.setLocale(localeCode);
  }
}
