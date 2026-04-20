import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class LoginProfileCard extends StatelessWidget {
  final VoidCallback onGotoLoginClick;

  const LoginProfileCard({super.key, required this.onGotoLoginClick});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          padding: EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(40),
            borderRadius: BorderRadius.circular(AppRadius.round),
          ),
          child: SvgPicture.asset(
            'assets/icons/profile.svg',
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          "Fruits Time",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onGotoLoginClick,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.round)),
              fixedSize: Size.fromHeight(36),
            ),
            child: Text(localization.loginTitle),
          ),
        ),
      ],
    );
  }
}
