import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:fruitstime/features/auth/domain/entity/status_tier_entity.dart';
import 'package:fruitstime/features/auth/presentation/controller/status_tiers_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

String _tierLabel(Tier tier, AppLocalizations l) => switch (tier) {
  Tier.silver => l.referralStatusSilver,
  Tier.gold => l.referralStatusGold,
  Tier.vip => l.referralStatusVip,
  Tier.premium => l.referralStatusPremium,
};

String _tierIconPath(Tier tier) => switch (tier) {
  Tier.silver => 'assets/icons/star.svg',
  Tier.gold => 'assets/icons/trophy.svg',
  Tier.vip => 'assets/icons/crown.svg',
  Tier.premium => 'assets/icons/crown.svg',
};

Color _tierColor(Tier tier) => switch (tier) {
  Tier.silver => const Color(0xff94a3b8),
  Tier.gold => const Color(0xfff5bd1f),
  Tier.vip => const Color(0xff8b5cf6),
  Tier.premium => const Color(0xff0ea5e9),
};

// Fallback used until the live user/status-tiers endpoint is reachable —
// keeps these numbers in sync with the backend's STATUS_TIERS constant.
final _fallbackTiers = [
  StatusTierEntity(status: Tier.silver, minReferrals: 0, discountPercent: 0),
  StatusTierEntity(status: Tier.gold, minReferrals: 1, discountPercent: 3),
  StatusTierEntity(status: Tier.vip, minReferrals: 6, discountPercent: 7),
  StatusTierEntity(status: Tier.premium, minReferrals: 11, discountPercent: 12),
];

class LoyaltyInfoModal extends ConsumerWidget {
  const LoyaltyInfoModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tiers = ref.watch(statusTiersProvider).value ?? _fallbackTiers;

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
        child: SingleChildScrollView(
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
              Divider(height: 1, color: scheme.onSurfaceVariant.withAlpha(40)),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.loyaltyInfoTiersTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    for (final tier in tiers) ...[
                      _TierPercentRow(tier: tier),
                      if (tier != tiers.last) SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ],
          ),
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

class _TierPercentRow extends StatelessWidget {
  final StatusTierEntity tier;

  const _TierPercentRow({required this.tier});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final color = _tierColor(tier.status);

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
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: SvgPicture.asset(
              _tierIconPath(tier.status),
              width: 18,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tierLabel(tier.status, localization),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                if (tier.minReferrals > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    localization.earnReferrals(tier.minReferrals),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: scheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${tier.discountPercent}%',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: color, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
