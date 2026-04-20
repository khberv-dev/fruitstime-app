import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:fruitstime/utils/lib.dart';

class _SummaryKeyText extends StatelessWidget {
  final String text;

  const _SummaryKeyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _SummaryValueText extends StatelessWidget {
  final String text;

  const _SummaryValueText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final int totalItemCount;
  final int totalItemTypeCount;
  final int totalCartPrice;

  const SummaryCard({
    super.key,
    required this.totalItemCount,
    required this.totalItemTypeCount,
    required this.totalCartPrice,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(40)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryKeyText(text: localization.productCountLabel),
              _SummaryValueText(text: totalItemCount.toString()),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryKeyText(text: localization.productTypeLabel),
              _SummaryValueText(text: totalItemTypeCount.toString()),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Divider(),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.totalLabel,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                "${formatNumber(totalCartPrice)} so'm",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
