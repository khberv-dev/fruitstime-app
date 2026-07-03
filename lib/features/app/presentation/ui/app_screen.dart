import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/domain/model/nav_item.dart';
import 'package:fruitstime/features/app/presentation/controller/bottom_navbar_provider.dart';
import 'package:fruitstime/features/app/presentation/ui/widget/bottom_navbar.dart';
import 'package:fruitstime/features/assistant/presentation/ui/widget/assistant_bubble.dart';
import 'package:fruitstime/features/auth/presentation/ui/profile_page.dart';
import 'package:fruitstime/features/cart/presentation/ui/cart_page.dart';
import 'package:fruitstime/features/catalog/presentation/ui/catalogs_page.dart';
import 'package:fruitstime/features/home/presentation/ui/home_page.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class AppScreen extends ConsumerStatefulWidget {
  static const path = '/app';

  const AppScreen({super.key});

  @override
  ConsumerState<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> with SingleTickerProviderStateMixin {
  double navbarPagerValue = 0;
  late final TabController bottomNavController;
  final GlobalKey _navbarKey = GlobalKey();
  double _navbarHeight = 64;

  @override
  void initState() {
    super.initState();
    bottomNavController = TabController(length: 4, vsync: this);

    bottomNavController.animation?.addListener(() {
      final animationComplete = !bottomNavController.animation!.isAnimating;
      final animationValue = bottomNavController.animation!.value;

      if (animationValue % 1 == 0 && animationComplete) {
        ref.read(bottomNavbarProvider.notifier).state = animationValue.round();
      }

      setState(() {
        navbarPagerValue = animationValue;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavbarHeight());
  }

  void _measureNavbarHeight() {
    final height = _navbarKey.currentContext?.size?.height;
    if (height != null && height != _navbarHeight && mounted) {
      setState(() => _navbarHeight = height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final navItems = [
      NavItem(text: localization.navHome, iconPath: 'assets/icons/home.svg'),
      NavItem(text: localization.catalogTitle, iconPath: 'assets/icons/grid.svg'),
      NavItem(text: localization.cartTitle, iconPath: 'assets/icons/cart.svg'),
      NavItem(text: localization.profileSection, iconPath: 'assets/icons/profile.svg'),
    ];

    final pages = [HomePage(), CatalogsPage(), CartPage(), ProfilePage()];

    ref.listen(bottomNavbarProvider, (_, state) {
      bottomNavController.animateTo(state, duration: Duration(milliseconds: 100));
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: TabBarView(controller: bottomNavController, children: pages),
            ),
            Positioned(
              bottom: AppSpacing.lg,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: BottomNavbar(
                key: _navbarKey,
                controller: bottomNavController,
                items: navItems,
                pagerValue: navbarPagerValue,
              ),
            ),
            Positioned(
              bottom: AppSpacing.lg + _navbarHeight + AppSpacing.md,
              right: AppSpacing.md,
              child: const AssistantBubble(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    bottomNavController.dispose();

    super.dispose();
  }
}
