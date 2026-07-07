import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:fruitstime/features/referral/domain/entity/referral_status_entity.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

(Color, Color) _tierColors(Tier tier) => switch (tier) {
  Tier.silver => (const Color(0xffe0e0e0), const Color(0xff616161)),
  Tier.gold => (const Color(0xfffff3cc), const Color(0xffd4a017)),
  Tier.vip => (const Color(0xffe8dcf5), const Color(0xff7b3fa0)),
  Tier.premium => (const Color(0xff1a1a1a).withAlpha(30), const Color(0xff1a1a1a)),
};

String _tierLabel(AppLocalizations localization, Tier tier) => switch (tier) {
  Tier.silver => localization.referralStatusSilver,
  Tier.gold => localization.referralStatusGold,
  Tier.vip => localization.referralStatusVip,
  Tier.premium => localization.referralStatusPremium,
};

const _tierMinReferrals = {Tier.silver: 0, Tier.gold: 1, Tier.vip: 6, Tier.premium: 11};

class ReferralCard extends StatelessWidget {
  final ReferralStatusEntity status;
  final VoidCallback onTap;

  const ReferralCard({super.key, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final (badgeBg, badgeFg) = _tierColors(status.status);
    final tierSegments = status.nextStatus != null
        ? _tierMinReferrals[status.nextStatus!]! - _tierMinReferrals[status.status]!
        : 0;
    final tierFilled = (status.count - _tierMinReferrals[status.status]!).clamp(0, tierSegments);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    color: scheme.secondary.withAlpha(40),
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/trophy.svg',
                    width: 20,
                    colorFilter: ColorFilter.mode(scheme.secondary, BlendMode.srcIn),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.referralCardTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        localization.referralCountLabel(status.count),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Text(
                    _tierLabel(localization, status.status),
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: badgeFg, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            if (status.nextStatus != null) ...[
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  for (int i = 0; i < tierSegments; i++) ...[
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: i < tierFilled
                              ? scheme.secondary
                              : scheme.onSurfaceVariant.withAlpha(30),
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                      ),
                    ),
                    if (i != tierSegments - 1) SizedBox(width: AppSpacing.xs),
                  ],
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                localization.referralRemainingToNextTier(
                  status.remaining,
                  _tierLabel(localization, status.nextStatus!),
                ),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: scheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
