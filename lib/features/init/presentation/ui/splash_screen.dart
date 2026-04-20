import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/bubble_icon.dart';
import 'package:fruitstime/features/init/domain/usecase/startup_route.dart';
import 'package:fruitstime/features/init/presentation/controller/startup_initiator.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const path = '/';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(startupInitiatorProvider.notifier).startup();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final startup = ref.watch(startupInitiatorProvider);

    ref.listen(startupInitiatorProvider, (_, state) {
      if (state.data != null) {
        context.go(ref.read(startupRouteProvider).call());
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BubbleIcon(color: Colors.white, iconPath: 'assets/icons/brand.svg'),
                SizedBox(height: AppSpacing.lg),
                Text(
                  "Fruits Time",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  localization.splashTagline,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.white.withAlpha(200)),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Center(
              child: SizedBox(
                width: 200,
                child: startup.isLoading ? LinearProgressIndicator() : SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
