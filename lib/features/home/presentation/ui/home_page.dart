import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/app/presentation/controller/bottom_navbar_provider.dart';
import 'package:fruitstime/features/assistant/presentation/ui/chat_screen.dart';
import 'package:fruitstime/features/auth/presentation/ui/controller/user_provider.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_birthday_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_gender_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_height_modal.dart';
import 'package:fruitstime/features/auth/presentation/ui/set_weight_modal.dart';
import 'package:fruitstime/features/banner/presentation/controller/banners_provider.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';
import 'package:fruitstime/features/catalog/presentation/controller/catalogs_provider.dart';
import 'package:fruitstime/features/catalog/presentation/controller/selected_catalog_provider.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/ai_card.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/catalog_row.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/go_search_card.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/home_header.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/request_fill_profile_card.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/special_offers_section.dart';
import 'package:fruitstime/features/product/presentation/ui/products_screen.dart';
import 'package:fruitstime/features/product/presentation/ui/search_screen.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannersProvider);
    final catalogs = ref.watch(catalogsProvider);
    final user = ref.watch(userProvider);
    final bool isProfileFilled =
        user.data?.birthday != null &&
        user.data?.weight != null &&
        user.data?.height != null &&
        user.data?.gender != null;

    void onShowCatalogsClick() {
      ref.read(bottomNavbarProvider.notifier).state = 1;
    }

    void onGotoAiClick() {
      context.push(ChatScreen.path);
    }

    void onCatalogItemClick(CatalogEntity catalog) {
      ref.read(selectedCatalogProvider.notifier).state = catalog;
      context.push(ProductsScreen.path);
    }

    void onGotoSearchClick() {
      context.push(SearchScreen.path);
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
            HomeHeader(userFirstName: user.data?.firstName),
            SizedBox(height: AppSpacing.xl),
            GoSearchCard(onPressed: onGotoSearchClick),
            SizedBox(height: AppSpacing.lg),
            if (!isProfileFilled && user.data != null) ...[
              RequestFillProfileCard(onClick: onFillProfileClick),
              SizedBox(height: AppSpacing.lg),
            ],
            SpecialOffersSection(banners: banners.data ?? []),
            SizedBox(height: AppSpacing.xl),
            AiCard(onPressed: onGotoAiClick),
            SizedBox(height: AppSpacing.lg),
            CatalogRow(
              catalogs: catalogs.data ?? [],
              onShowAllClick: onShowCatalogsClick,
              onItemClick: onCatalogItemClick,
            ),
          ],
        ),
      ),
    );
  }
}
