import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';
import 'package:fruitstime/features/catalog/presentation/ui/widget/catalog_grid_item.dart';

class CatalogGrid extends StatelessWidget {
  final List<CatalogEntity> catalogs;
  final Function(CatalogEntity) onItemClick;

  const CatalogGrid({super.key, required this.catalogs, required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: catalogs.length,
      padding: EdgeInsets.only(top: AppSpacing.xl, bottom: 96),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (_, index) => GestureDetector(
        onTap: () => onItemClick(catalogs[index]),
        child: CatalogGridItem(catalog: catalogs[index]),
      ),
    );
  }
}
