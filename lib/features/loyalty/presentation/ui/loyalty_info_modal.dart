import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class LoyaltyInfoModal extends StatelessWidget {
  const LoyaltyInfoModal({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final steps = [
      localization.loyaltyInfoStep1,
      localization.loyaltyInfoStep2,
      localization.loyaltyInfoStep3,
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withAlpha(60),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: SvgPicture.asset(
                  'assets/icons/crown.svg',
                  width: 26,
                  colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                localization.loyaltyCardTitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.lg),
              child: Center(
                child: Text(
                  localization.loyaltyInfoSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: scheme.onSurfaceVariant, fontSize: 13),
                ),
              ),
            ),
            Divider(height: 1, color: scheme.onSurfaceVariant.withAlpha(40)),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  for (int i = 0; i < steps.length; i++) ...[
                    _StepRow(number: i + 1, text: steps[i]),
                    if (i != steps.length - 1) SizedBox(height: AppSpacing.sm),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;

  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: Text(
              '$number',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: scheme.onPrimary, fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
