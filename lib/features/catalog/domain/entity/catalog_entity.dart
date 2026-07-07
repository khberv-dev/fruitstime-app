import 'package:fruitstime/features/catalog/data/enum/catalog_type.dart';

class CatalogEntity {
  final String id;
  final String title;
  final String imageUrl;
  final int productsCount;
  final CatalogType type;

  CatalogEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.productsCount,
    required this.type,
  });
}
