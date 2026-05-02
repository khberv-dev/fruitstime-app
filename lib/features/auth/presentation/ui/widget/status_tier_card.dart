import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/auth/data/enum/tier.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class StatusTierCard extends StatelessWidget {
  final Tier tier;
  final VoidCallback? onInfoPressed;

  const StatusTierCard({super.key, required this.tier, this.onInfoPressed});

  Color _color() => switch (tier) {
    Tier.silver => const Color(0xff94a3b8),
    Tier.gold => const Color(0xfff5bd1f),
    Tier.vip => const Color(0xff8b5cf6),
  };

  String _iconPath() => switch (tier) {
    Tier.silver => 'assets/icons/star.svg',
    Tier.gold => 'assets/icons/trophy.svg',
    Tier.vip => 'assets/icons/crown.svg',
  };

  String _heading(AppLocalizations l) => switch (tier) {
    Tier.silver => l.statusSilverHeading,
    Tier.gold => l.statusGoldHeading,
    Tier.vip => l.statusVipHeading,
  };

  String _subtitle(AppLocalizations l) => switch (tier) {
    Tier.silver => l.tierSilverDescription,
    Tier.gold => l.tierGoldDescription,
    Tier.vip => l.tierVipDescription,
  };

  String? _discount() => switch (tier) {
    Tier.silver => null,
    Tier.gold => '5%',
    Tier.vip => '7%',
  };

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final color = _color();
    final discount = _discount();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: SvgPicture.asset(
                    _iconPath(),
                    width: 24,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _heading(localization),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(localization),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onInfoPressed != null)
                  IconButton(
                    onPressed: onInfoPressed,
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.all(8),
                      shape: const CircleBorder(),
                      side: BorderSide.none,
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/info.svg',
                      width: 16,
                      colorFilter: ColorFilter.mode(scheme.onSurfaceVariant, BlendMode.srcIn),
                    ),
                  ),
              ],
            ),
          ),
          if (discount != null) ...[
            Divider(height: 1, color: scheme.onSurfaceVariant.withAlpha(40)),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localization.currentDiscount,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    discount,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
