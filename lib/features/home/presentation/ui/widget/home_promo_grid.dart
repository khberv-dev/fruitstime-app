import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/home_promo_card.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class HomePromoGrid extends StatelessWidget {
  final VoidCallback onCardTap;

  const HomePromoGrid({super.key, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SizedBox(
      height: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: HomePromoCard(
                    title: localization.homePromoSmoothieTitle,
                    subtitle: localization.homePromoSmoothieSubtitle,
                    buttonLabel: localization.homePromoSmoothieButton,
                    imagePath: 'assets/images/smoothie_fresh.png',
                    scrimColor: const Color(0xff2f6b3f),
                    onTap: onCardTap,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Expanded(
                  child: HomePromoCard(
                    title: localization.homePromoVitaminTitle,
                    subtitle: localization.homePromoVitaminSubtitle,
                    buttonLabel: localization.homePromoVitaminButton,
                    imagePath: 'assets/images/vitamin.png',
                    scrimColor: const Color(0xffe0562b),
                    onTap: onCardTap,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: HomePromoCard(
              title: localization.homePromoDeliveryTitle,
              subtitle: localization.homePromoDeliverySubtitle,
              buttonLabel: localization.homePromoDeliveryButton,
              imagePath: 'assets/images/delivery.png',
              scrimColor: const Color(0xff2f6b3f),
              onTap: onCardTap,
            ),
          ),
        ],
      ),
    );
  }
}
