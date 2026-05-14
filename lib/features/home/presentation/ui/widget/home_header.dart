import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  final String? branchName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBranchTap;

  const HomeHeader({super.key, this.branchName, this.onNotificationTap, this.onBranchTap});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onBranchTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.pickUpFrom,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(Icons.store_outlined, color: theme.colorScheme.primary, size: 18),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    branchName ?? '—',
                    style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Icon(Icons.unfold_more, color: theme.colorScheme.onSurface, size: 18),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotificationTap ?? () {},
          icon: const Icon(Icons.notifications_outlined, size: 20),
        ),
      ],
    );
  }
}
