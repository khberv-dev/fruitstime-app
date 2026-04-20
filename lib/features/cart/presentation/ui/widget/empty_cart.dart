import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/core/ui/widget/bubble_icon.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BubbleIcon(color: Theme.of(context).colorScheme.primary, iconPath: 'assets/icons/cart.svg'),
        SizedBox(height: AppSpacing.xl),
        Text(
          localization.cartEmpty,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
