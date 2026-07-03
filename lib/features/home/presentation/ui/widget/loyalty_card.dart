import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/loyalty/domain/entity/loyalty_status_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

const _loyaltyInterval = 10;

class LoyaltyCard extends StatelessWidget {
  final LoyaltyStatusEntity status;

  const LoyaltyCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final filled = status.itemsOrdered % _loyaltyInterval;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: SvgPicture.asset(
                  'assets/icons/crown.svg',
                  width: 20,
                  colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.loyaltyCardTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      localization.loyaltyItemsOrderedLabel(status.itemsOrdered),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (int i = 0; i < _loyaltyInterval; i++) ...[
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: i < filled ? scheme.primary : scheme.onSurfaceVariant.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                  ),
                ),
                if (i != _loyaltyInterval - 1) SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            localization.loyaltyItemsUntilNextBonus(status.itemsUntilNextFree),
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
