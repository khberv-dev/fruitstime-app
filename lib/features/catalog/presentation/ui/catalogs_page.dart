import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';
import 'package:fruitstime/features/catalog/presentation/controller/catalogs_provider.dart';
import 'package:fruitstime/features/catalog/presentation/controller/selected_catalog_provider.dart';
import 'package:fruitstime/features/catalog/presentation/ui/widget/catalog_grid.dart';
import 'package:fruitstime/features/catalog/presentation/ui/widget/catalogs_header.dart';
import 'package:fruitstime/features/product/presentation/ui/products_screen.dart';
import 'package:go_router/go_router.dart';

class CatalogsPage extends ConsumerWidget {
  const CatalogsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogs = ref.watch(catalogsProvider);

    void onCatalogClick(CatalogEntity catalog) {
      ref.read(selectedCatalogProvider.notifier).state = catalog;
      context.push(ProductsScreen.path);
    }

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          CatalogsHeader(),
          Expanded(
            child: CatalogGrid(catalogs: catalogs.data ?? [], onItemClick: onCatalogClick),
          ),
        ],
      ),
    );
  }
}
