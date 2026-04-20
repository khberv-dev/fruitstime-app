import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';
import 'package:fruitstime/features/home/presentation/ui/widget/catalog_row_item.dart';
import 'package:fruitstime/l10n/app_localizations.dart';

class CatalogRow extends ConsumerWidget {
  final List<CatalogEntity> catalogs;
  final VoidCallback onShowAllClick;
  final Function(CatalogEntity) onItemClick;

  const CatalogRow({
    super.key,
    required this.catalogs,
    required this.onShowAllClick,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.catalogTitle,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
            ),
            TextButton(onPressed: onShowAllClick, child: Text(localization.showAllButton)),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              catalogs.length,
              (index) => Row(
                children: [
                  GestureDetector(
                    onTap: () => onItemClick(catalogs[index]),
                    child: CatalogRowItem(catalog: catalogs[index]),
                  ),
                  SizedBox(width: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
