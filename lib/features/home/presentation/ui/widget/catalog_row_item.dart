import 'package:flutter/material.dart';
import 'package:fruitstime/core/theme/app_radius.dart';
import 'package:fruitstime/core/theme/app_spacing.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';

class CatalogRowItem extends StatelessWidget {
  final CatalogEntity catalog;

  const CatalogRowItem({super.key, required this.catalog});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Stack(
        children: [
          Positioned.fill(
            child: FadeInImage(
              placeholder: AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(catalog.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              decoration: BoxDecoration(color: Colors.black.withAlpha(100)),
              child: Text(
                catalog.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
