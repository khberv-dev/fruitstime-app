import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/controller/app_locale.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/init/domain/usecase/save_locale.dart';
import 'package:fruitstime/features/init/presentation/ui/widget/locale_select.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SelectLocaleScreen extends ConsumerStatefulWidget {
  static const path = '/locale';

  const SelectLocaleScreen({super.key});

  @override
  ConsumerState<SelectLocaleScreen> createState() => _SelectLocaleScreenState();
}

class _SelectLocaleScreenState extends ConsumerState<SelectLocaleScreen> {
  int? selectedLocaleIndex;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final saveLocale = ref.read(saveLocaleProvider);
    final localeNotifier = ref.read(appLocaleProvider.notifier);
    final availableLocales = ref.read(availableLocalesProvider);

    void onLocaleItemClick(int index) {
      setState(() {
        selectedLocaleIndex = index;
      });

      localeNotifier.setLocale(availableLocales[index].localeCode);
    }

    void onContinueClick() {
      saveLocale.call(availableLocales[selectedLocaleIndex!].localeCode);

      context.go('/onboarding');
    }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.lg),
                Text(
                  localization.selectLanguageTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 48,
                  child: Text(
                    localization.selectLanguageDescription,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),
                LocaleSelect(
                  items: availableLocales,
                  current: selectedLocaleIndex,
                  onItemClick: onLocaleItemClick,
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: selectedLocaleIndex != null ? onContinueClick : null,
                    child: Text(localization.continueButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
