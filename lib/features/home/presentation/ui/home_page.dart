import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/presentation/controller/bottom_navbar_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_birthday_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_gender_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_height_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_weight_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/status_info_modal.dart';
import 'package:fruitstime/features/banner/presentation/controller/banners_provider.dart';
import 'package:fruitstime/features/banner/presentation/ui/stories_screen.dart';
import 'package:fruitstime/features/branch/presentation/controller/branches_provider.dart';
import 'package:fruitstime/features/branch/presentation/ui/branch_selector_modal.dart';
import 'package:fruitstime/features/catalog/data/enum/catalog_type.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';
import 'package:fruitstime/features/catalog/presentation/controller/catalogs_provider.dart';
import 'package:fruitstime/features/catalog/presentation/controller/selected_catalog_provider.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/banner_stories_row.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/catalog_row.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/home_header.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/home_promo_grid.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/loyalty_card.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/referral_card.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/request_fill_profile_card.dart';
import 'package:fruitstime/features/loyalty/presentation/controller/loyalty_status_provider.dart';
import 'package:fruitstime/features/loyalty/presentation/ui/loyalty_info_modal.dart';
import 'package:fruitstime/features/notification/presentation/ui/notifications_screen.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/presentation/controller/active_order_provider.dart';
import 'package:fruitstime/features/order/presentation/ui/web_view_screen.dart';
import 'package:fruitstime/features/order/presentation/ui/widget/order_card.dart';
import 'package:fruitstime/features/order/presentation/ui/widget/order_detail_sheet.dart';
import 'package:fruitstime/features/product/presentation/ui/products_screen.dart';
import 'package:fruitstime/features/referral/presentation/controller/referral_status_provider.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _showPopupBannerIfAny);
  }

  void _showPopupBannerIfAny() {
    if (!mounted) return;

    final banners = ref.read(bannersProvider).data ?? [];
    final index = banners.indexWhere((banner) => banner.popup);
    if (index == -1) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.black,
      builder: (_) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.95,
        child: StoriesScreen(banners: banners, initialIndex: index),
      ),
    );
  }

  void _onActiveOrderTap(BuildContext context, OrderEntity order) {
    if (order.link != null) {
      context.push(WebViewScreen.path, extra: order.link!);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (_) => OrderDetailSheet(order: order),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannersProvider);
    final catalogs = ref.watch(catalogsProvider);
    final user = ref.watch(userProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);
    final activeOrder = ref.watch(activeOrderProvider);
    final loyaltyStatus = ref.watch(loyaltyStatusProvider);
    final referralStatus = ref.watch(referralStatusProvider);
    final bool isProfileFilled =
        user.data?.birthday != null &&
        user.data?.weight != null &&
        user.data?.height != null &&
        user.data?.gender != null;

    void onShowCatalogsClick() {
      ref.read(bottomNavbarProvider.notifier).state = 1;
    }

    void onCatalogItemClick(CatalogEntity catalog) {
      ref.read(selectedCatalogProvider.notifier).state = catalog;
      context.push(ProductsScreen.path);
    }

    void onVitaminCardClick() {
      final vitaminCatalog = (catalogs.data ?? const [])
          .where((catalog) => catalog.type == CatalogType.vitamin)
          .firstOrNull;

      if (vitaminCatalog != null) {
        onCatalogItemClick(vitaminCatalog);
      } else {
        onShowCatalogsClick();
      }
    }

    void onLoyaltyCardClick() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (_) => const LoyaltyInfoModal(),
      );
    }

    void onReferralCardClick() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (_) => const StatusInfoModal(),
      );
    }

    void onFillProfileClick() {
      ref.read(bottomNavbarProvider.notifier).state = 3;

      Widget modalWidget = SetGenderModal();

      if (user.data?.weight == null) {
        modalWidget = SetWeightModal();
      }

      if (user.data?.height == null) {
        modalWidget = SetHeightModal();
      }

      if (user.data?.birthday == null) {
        modalWidget = SetBirthdayModal();
      }

      showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => modalWidget);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 96),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(
              branchName: selectedBranch?.name,
              onBranchTap: () => showModalBottomSheet(
                context: context,
                builder: (_) => const BranchSelectorModal(),
              ),
              onNotificationTap: () => context.push(NotificationsScreen.path),
            ),
            SizedBox(height: AppSpacing.xl),
            if (activeOrder.value != null) ...[
              OrderCard(
                order: activeOrder.value!,
                onTap: () => _onActiveOrderTap(context, activeOrder.value!),
                glow: true,
              ),
              SizedBox(height: AppSpacing.lg),
            ],
            if (!isProfileFilled && user.data != null) ...[
              RequestFillProfileCard(onClick: onFillProfileClick),
              SizedBox(height: AppSpacing.lg),
            ],
            BannerStoriesRow(banners: banners.data ?? []),
            SizedBox(height: AppSpacing.lg),
            HomePromoGrid(onCardTap: onShowCatalogsClick, onVitaminCardTap: onVitaminCardClick),
            SizedBox(height: AppSpacing.lg),
            CatalogRow(
              catalogs: catalogs.data ?? [],
              onShowAllClick: onShowCatalogsClick,
              onItemClick: onCatalogItemClick,
            ),
            SizedBox(height: AppSpacing.lg),
            if (loyaltyStatus.data?.isActive ?? false) ...[
              LoyaltyCard(status: loyaltyStatus.data!, onTap: onLoyaltyCardClick),
              SizedBox(height: AppSpacing.lg),
            ],
            if (referralStatus.data != null) ...[
              ReferralCard(status: referralStatus.data!, onTap: onReferralCardClick),
              SizedBox(height: AppSpacing.lg),
            ],
          ],
        ),
      ),
    );
  }
}
