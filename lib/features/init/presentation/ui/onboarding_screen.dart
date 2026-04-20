import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/init/domain/model/onboarding_illustration.dart';
import 'package:fruitstime/features/init/domain/usecase/pass_onboarding.dart';
import 'package:fruitstime/features/init/presentation/ui/widget/onboarding_carousel.dart';
import 'package:fruitstime/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static const path = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int carouselIndex = 0;
  final controller = PageController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        carouselIndex = controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final passOnboarding = ref.read(passOnboardingProvider);

    final carouselItems = [
      OnboardingIllustration(
        title: localization.onboarding1Title,
        description: localization.onboarding1Description,
        imagePath: 'assets/images/illustration_1.png',
      ),
      OnboardingIllustration(
        title: localization.onboarding2Title,
        description: localization.onboarding2Description,
        imagePath: 'assets/images/illustration_2.png',
      ),
      OnboardingIllustration(
        title: localization.onboarding3Title,
        description: localization.onboarding3Description,
        imagePath: 'assets/images/illustration_3.png',
      ),
    ];

    void onSkipClick() {
      passOnboarding.call();

      context.go('/app');
    }

    void onContinueClick() {
      if (carouselIndex < carouselItems.length - 1) {
        controller.animateToPage(
          carouselIndex + 1,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else {
        onSkipClick();
      }
    }

    return Scaffold(
      body: Column(
        children: [
          OnboardingCarousel(
            controller: controller,
            items: carouselItems,
            progressValue: carouselIndex,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onContinueClick,
                child: Text(localization.continueButton),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(onPressed: onSkipClick, child: Text(localization.skipButton)),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}
