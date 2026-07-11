import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class LoginToOrderCard extends StatelessWidget {
  final VoidCallback onLoginClick;

  const LoginToOrderCard({super.key, required this.onLoginClick});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.onSurfaceVariant.withAlpha(40)),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 26,
              colorFilter: ColorFilter.mode(scheme.primary, BlendMode.srcIn),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            localization.loginToOrderTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            localization.loginToOrderSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onLoginClick,
              child: Text(localization.loginToOrderButton),
            ),
          ),
        ],
      ),
    );
  }
}
