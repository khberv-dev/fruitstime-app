import 'package:flutter/material.dart';
import 'package:fruitstime/core/model/app_locale.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';

class LocaleSelectOption extends StatelessWidget {
  final AppLocale item;
  final bool isCurrent;

  const LocaleSelectOption({super.key, required this.item, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final bgColor = isCurrent
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;
    final textColor = isCurrent
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        child: Text(
          item.localeName,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: textColor),
        ),
      ),
    );
  }
}
