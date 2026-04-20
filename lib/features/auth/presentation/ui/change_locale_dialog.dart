import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/controller/app_locale.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/init/domain/usecase/save_locale.dart';
import 'package:fruitstime/features/init/presentation/ui/splash_screen.dart';
import 'package:fruitstime/features/init/presentation/ui/widget/locale_select.dart';
import 'package:go_router/go_router.dart';

class ChangeLocaleDialog extends ConsumerWidget {
  const ChangeLocaleDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableLocales = ref.read(availableLocalesProvider);
    final saveLocale = ref.read(saveLocaleProvider);
    final localeNotifier = ref.read(appLocaleProvider.notifier);

    void onLocaleItemClick(int index) {
      saveLocale.call(availableLocales[index].localeCode);
      localeNotifier.setLocale(availableLocales[index].localeCode);

      context.go(SplashScreen.path);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tilni tanlang",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: AppSpacing.md),
            LocaleSelect(items: availableLocales, current: null, onItemClick: onLocaleItemClick),
          ],
        ),
      ),
    );
  }
}
