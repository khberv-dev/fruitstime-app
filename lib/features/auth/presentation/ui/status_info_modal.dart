import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class StatusInfoModal extends StatelessWidget {
  const StatusInfoModal({super.key});

  String _label(Tier tier, AppLocalizations l) => switch (tier) {
    Tier.silver => l.tierSilver,
    Tier.gold => l.tierGold,
    Tier.vip => l.tierVip,
  };

  String _iconPath(Tier tier) => switch (tier) {
    Tier.silver => 'assets/icons/star.svg',
    Tier.gold => 'assets/icons/trophy.svg',
    Tier.vip => 'assets/icons/crown.svg',
  };

  Color _badgeColor(Tier tier) => switch (tier) {
    Tier.silver => const Color(0xff94a3b8),
    Tier.gold => const Color(0xfff5bd1f),
    Tier.vip => const Color(0xff8b5cf6),
  };

  Color _pillBg(Tier tier) => switch (tier) {
    Tier.silver => const Color(0xfff1f5f9),
    Tier.gold => const Color(0xfffff3cc),
    Tier.vip => const Color(0xfff3e8ff),
  };

  Color _pillFg(Tier tier) => switch (tier) {
    Tier.silver => const Color(0xff64748b),
    Tier.gold => const Color(0xffd4a017),
    Tier.vip => const Color(0xff7c3aed),
  };

  int _referrals(Tier tier) => switch (tier) {
    Tier.silver => 5,
    Tier.gold => 10,
    Tier.vip => 15,
  };

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

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
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Center(
              child: Text(
                localization.statusInfoSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
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
                    pillBg: _pillBg(tier),
                    pillFg: _pillFg(tier),
                    count: _referrals(tier),
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
  final Color pillBg;
  final Color pillFg;
  final int count;

  const _TierRow({
    required this.label,
    required this.iconPath,
    required this.badgeColor,
    required this.pillBg,
    required this.pillFg,
    required this.count,
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
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  localization.earnReferrals(count),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: Text(
              localization.referralCountShort(count),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: pillFg,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
