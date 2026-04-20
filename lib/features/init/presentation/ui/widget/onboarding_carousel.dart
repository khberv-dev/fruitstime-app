import 'package:flutter/material.dart';
import 'package:fruitstime/core/ui/widget/dot_progress.dart';
import 'package:fruitstime/features/init/domain/model/onboarding_illustration.dart';
import 'package:fruitstime/features/init/presentation/ui/widget/onboarding_carousel_item.dart';

class OnboardingCarousel extends StatelessWidget {
  final PageController controller;
  final List<OnboardingIllustration> items;
  final int progressValue;

  const OnboardingCarousel({
    super.key,
    required this.controller,
    required this.items,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 450,
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            itemBuilder: (_, index) => OnboardingCarouselItem(item: items[index]),
          ),
        ),
        DotProgress(value: progressValue, max: items.length),
      ],
    );
  }
}
