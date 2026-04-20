import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/init/domain/model/onboarding_illustration.dart';

class OnboardingCarouselItem extends StatelessWidget {
  final OnboardingIllustration item;

  const OnboardingCarouselItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(item.imagePath, width: double.infinity, height: 300, fit: BoxFit.cover),
        SizedBox(height: AppSpacing.xxl),
        Text(
          item.title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
        ),
        SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            item.description,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
