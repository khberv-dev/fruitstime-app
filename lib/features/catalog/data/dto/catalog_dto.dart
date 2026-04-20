import 'package:fruitstime/core/data/network/config.dart';
import 'package:fruitstime/features/catalog/domain/entity/catalog_entity.dart';

class CatalogDto {
  final String id;
  final String title;
  final String image;
  final int productsCount;

  CatalogDto({
    required this.id,
    required this.title,
    required this.image,
    required this.productsCount,
  });

  factory CatalogDto.parse(Map<String, dynamic> data) => CatalogDto(
    id: data['id'],
    title: data['title'],
    image: data['image'],
    productsCount: data['productsCount'],
  );

  CatalogEntity toEntity() => CatalogEntity(
    id: id,
    title: title,
    imageUrl: '$baseCdnUrl/catalog/$image',
    productsCount: productsCount,
  );
}
