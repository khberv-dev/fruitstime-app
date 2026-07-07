import 'package:fruitstime/core/data/network/config.dart';
import 'package:fruitstime/features/catalog/data/enum/catalog_type.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';

class CatalogDto {
  final String id;
  final String title;
  final String image;
  final int productsCount;
  final CatalogType type;

  CatalogDto({
    required this.id,
    required this.title,
    required this.image,
    required this.productsCount,
    required this.type,
  });

  factory CatalogDto.parse(Map<String, dynamic> data) => CatalogDto(
    id: data['id'],
    title: data['title'],
    image: data['image'],
    productsCount: data['productsCount'],
    type: CatalogType.values.byName(data['type']),
  );

  CatalogEntity toEntity() => CatalogEntity(
    id: id,
    title: title,
    imageUrl: '$baseCdnUrl/catalog/$image',
    productsCount: productsCount,
    type: type,
  );
}
