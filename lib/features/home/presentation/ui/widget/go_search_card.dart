import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class GoSearchCard extends StatelessWidget {
  final VoidCallback onPressed;

  const GoSearchCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(width: AppSpacing.lg),
            Text(
              localization.searchJuicesHint,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
