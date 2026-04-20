import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/controller/app_locale.dart';
import 'package:fruitstime/core/router/app_router.dart';
import 'package:fruitstime/core/theme/app_theme.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final appTheme = ref.read(appThemeProvider);
    final appRouter = ref.read(appRouterProvider);
    final appLocale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: appTheme,
      locale: appLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}
