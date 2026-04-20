import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class AiCard extends StatelessWidget {
  final VoidCallback onPressed;

  const AiCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary.withAlpha(200),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.aiAssistantTitle,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    localization.aiAssistantDescription,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  IgnorePointer(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        fixedSize: Size(128, 36),
                        backgroundColor: Theme.of(context).colorScheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.round),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        localization.goButton,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary.withAlpha(50),
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
              child: SvgPicture.asset(
                'assets/icons/ai.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
