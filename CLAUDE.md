# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `flutter pub get` — install dependencies
- `flutter run` — run on the connected device/emulator (debug build hits the test host, see Networking)
- `flutter analyze` — static analysis using the rules in `analysis_options.yaml` (extends `flutter_lints`, page width 100)
- `dart format .` — format (page width is 100)
- `flutter test` — run all tests; `flutter test test/path/file_test.dart` for a single file
- `flutter gen-l10n` — regenerate localization Dart from ARBs in `lib/l10n` (config is in `l10n.yaml`; runs automatically on build because `generate: true` is set in `pubspec.yaml`)
- `dart run flutter_launcher_icons` — regenerate launcher icons from `assets/images/brand.png`
- Release builds: `flutter build apk --release` / `flutter build appbundle` / `flutter build ipa`. The Android signing keystore lives in `keys/upload-keystore.jks`; do not commit changes to anything in `keys/`.

## Architecture

Feature-sliced clean architecture. Every feature under `lib/features/<feature>` follows the same three-layer split, and crossing layers should always go inward (`presentation → domain → data`):

- `data/` — `dto/` (JSON parsing + `toEntity()`), `repository/` (Dio calls only, returns DTOs), optional `enum/`. Repositories must not contain business logic.
- `domain/` — `entity/` (UI-facing models), `usecase/` (one class per action, exposes a `call(...)` method and a Riverpod `Provider`), optional `model/`, `enum/`.
- `presentation/` — `ui/` (screens, modals, `widget/` subfolder for feature-local widgets) and `controller/` (Riverpod notifiers that drive screens). UI never calls repositories directly; it goes through usecases via a controller.

Cross-cutting code lives in `lib/core`:
- `core/data/network/` — Dio setup (`api_client.dart`), `ApiClientInterceptor` (auth header + locale query param + 401 refresh-and-retry), `config.dart` host URLs, and `RequestState<T>` (the standard `{data, error, message, isLoading}` envelope every controller emits).
- `core/data/cache/` — `CacheService` interface + `CacheServiceImpl` over `SharedPreferences`. Storage keys are centralized in `keys.dart`.
- `core/router/app_router.dart` — single `GoRouter`. Routes are registered by reading each screen's `static const path` (e.g. `SplashScreen.path = '/'`, `AppScreen.path = '/app'`). When adding a screen, declare its `path` on the widget and register it here.
- `core/theme/` — `AppTheme` (Material color scheme + Inter via `google_fonts`) and the `AppSpacing` / `AppRadius` constant scales. Use these constants instead of magic numbers.
- `core/controller/app_locale.dart` — locale notifier and the canonical list of supported locales (`uz` default, `en`, `ru`).

### Riverpod conventions

Riverpod 3 is the only state management. The repeated patterns are:

- Repository → `Provider((ref) => XRepository(ref.read(apiClientProvider)))`.
- Usecase → `Provider((ref) => XUseCase(ref.read(...)))`, exposing a single `call(...)`.
- Screen-facing state → `NotifierProvider` whose `Notifier` holds `RequestState<T>`. The standard shape inside an action is: set `RequestState.loading()`, `await` the usecase, set `RequestState.data(...)` on success, catch `DioException` and set `RequestState.error(e.message)`. See `features/auth/presentation/ui/controller/login_user_provider.dart` for the canonical example.
- Screens listen for navigation/error side effects with `ref.listen(provider, ...)` and call `showErrorMessage(context, ...)` from `utils/messanger.dart` for snackbars.

### App bootstrap and startup flow

- `main.dart` initializes `SharedPreferences` synchronously, builds a `CacheServiceImpl`, and overrides `cacheProvider` in `ProviderScope` — this is why `cacheProvider` is declared with `throw UnimplementedError()`. Anything that needs cache before `runApp` must be wired the same way.
- The first route is `SplashScreen` (`/`). It triggers `startupInitiatorProvider`, which loads banners + catalogs + the current user, then `StartupRoute` decides where to go: no locale → `/select-locale`, onboarding not passed → `/onboarding`, else `/app`. `AppScreen` is a 4-tab `TabBarView` (Home, Catalogs, Cart, Profile) controlled by `bottomNavbarProvider`.

### Networking

- Base URL switches by build mode in `core/data/network/config.dart`: `kDebugMode` uses `http://192.168.0.39:8000` (a LAN dev host — update this IP for your machine), release uses `https://fruitstime.uz`. `baseCdnUrl` follows the same host and serves images under `/public/...` (e.g. `ProductDto.toEntity()` builds `$baseCdnUrl/product/$image`).
- `ApiClientInterceptor` automatically attaches `Authorization: Bearer <accessToken>` on every non-`auth/*` request, appends `?locale=<code>` to every request, and on a 401 transparently calls `auth/refresh`, persists the new tokens, and retries the original request once. New endpoints under the `auth/` path prefix are intentionally exempt from both auth header and refresh.
- API errors: the interceptor unwraps `response.data['message']` (string or list) into `DioException.message`, so controllers can surface `e.message` directly to users.

### Localization

- ARB files live in `lib/l10n/` with `app_uz.arb` as the template (see `l10n.yaml`). Generated Dart goes to `lib/l10n/app_localizations*.dart`.
- Add a new string by editing all three ARBs (`uz`, `en`, `ru`) and rebuilding; never hard-code user-visible strings in widgets — pull from `AppLocalizations.of(context)!`.
- The `locale` query param the API sees is whatever `CacheService.getLocale()` returns (defaults to `uz` in the interceptor when unset).

## Conventions worth knowing

- DTOs convert to entities via `toEntity()`; UI and usecases work with entities only.
- Each route screen exposes its path as `static const path = '/...'`. Use `context.go(Screen.path)` / `context.replace(...)` rather than string literals.
- Use `AppSpacing.*` / `AppRadius.*` for paddings, gaps, and radii. The theme already styles `FilledButton`, `IconButton`, `InputDecoration`, dividers, and the progress indicator — prefer theme-driven styling over per-widget overrides.
- Phone numbers are Uzbek-only: input is masked via `PhoneNumberFormatter`, `extractDigits` strips formatting, and the `998` country code is prepended at the call site before sending to the API.
