import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/app.dart';
import 'package:fruitstime/core/data/cache/cache_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final cacheService = CacheServiceImpl(sharedPreferences);

  runApp(ProviderScope(overrides: [cacheProvider.overrideWithValue(cacheService)], child: App()));
}
