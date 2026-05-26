import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/app.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_maps_mapkit/init.dart' as yandex_maps;

const _yandexMapKitApiKey = '9b104dbc-7702-4a81-a7c4-e03acf385e52';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await yandex_maps.initMapkit(apiKey: _yandexMapKitApiKey);

  final sharedPreferences = await SharedPreferences.getInstance();
  final cacheService = CacheServiceImpl(sharedPreferences);

  runApp(ProviderScope(overrides: [cacheProvider.overrideWithValue(cacheService)], child: App()));
}
