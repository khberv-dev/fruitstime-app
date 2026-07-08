import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:fruitstime/features/auth/presentation/controller/status_tiers_provider.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class StatusInfoModal extends ConsumerWidget {
  const StatusInfoModal({super.key});

  String _label(Tier tier, AppLocalizations l) => switch (tier) {
    Tier.silver => l.tierSilver,
    Tier.gold => l.tierGold,
    Tier.vip => l.tierVip,
    Tier.premium => l.tierPremium,
  };

  String _iconPath(Tier tier) => switch (tier) {
    Tier.silver => 'assets/icons/star.svg',
    Tier.gold => 'assets/icons/trophy.svg',
    Tier.vip => 'assets/icons/crown.svg',
    Tier.premium => 'assets/icons/crown.svg',
  };

  Color _badgeColor(Tier tier) => switch (tier) {
    Tier.silver => const Color(0xff94a3b8),
    Tier.gold => const Color(0xfff5bd1f),
    Tier.vip => const Color(0xff8b5cf6),
    Tier.premium => const Color(0xff0ea5e9),
  };

  int _referrals(Tier tier) => switch (tier) {
    Tier.silver => 0,
    Tier.gold => 1,
    Tier.vip => 6,
    Tier.premium => 11,
  };

  // Fallback used until the live user/status-tiers endpoint is reachable —
  // keeps these numbers in sync with the backend's STATUS_TIERS constant.
  int _fallbackDiscountPercent(Tier tier) => switch (tier) {
    Tier.silver => 0,
    Tier.gold => 3,
    Tier.vip => 7,
    Tier.premium => 12,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final statusTiers = ref.watch(statusTiersProvider).value;
    final discountByTier = {
      for (final tier in statusTiers ?? []) tier.status: tier.discountPercent,
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
            child: Text(
              localization.statusInfoTitle,
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
                localization.statusInfoSubtitle,
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
                for (final tier in Tier.values) ...[
                  _TierRow(
                    label: _label(tier, localization),
                    iconPath: _iconPath(tier),
                    badgeColor: _badgeColor(tier),
                    count: _referrals(tier),
                    discountPercent: discountByTier[tier] ?? _fallbackDiscountPercent(tier),
                  ),
                  if (tier != Tier.values.last) SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color badgeColor;
  final int count;
  final int discountPercent;

  const _TierRow({
    required this.label,
    required this.iconPath,
    required this.badgeColor,
    required this.count,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
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
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                count > 0
                    ? Text(
                        localization.earnReferrals(count),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            '$discountPercent%',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: badgeColor, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
