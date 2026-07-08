import 'package:fruitstime/core/data/network/config.dart';
import 'package:fruitstime/features/product/data/dto/product_promotion_dto.dart';
import 'package:fruitstime/features/product/data/enum/product_type.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class ProductDto {
  final String id;
  final int? posId;
  final String title;
  final String description;
  final String image;
  final List<String> compound;
  final int price;
  final ProductType type;
  final List<ProductAvailability> available;
  final List<ProductPromotionDto> promotions;

  ProductDto({
    required this.id,
    this.posId,
    required this.title,
    required this.description,
    required this.image,
    required this.compound,
    required this.price,
    required this.type,
    this.available = const [],
    this.promotions = const [],
  });

  factory ProductDto.parse(Map<String, dynamic> data) {
    final rawAvailable = data['available'];
    final available = rawAvailable is List
        ? rawAvailable
              .map(
                (e) =>
                    ProductAvailability(storageId: e['storage_id'] as int, left: e['left'] as bool),
              )
              .toList()
        : <ProductAvailability>[];

    final rawPromotions = data['promotions'];
    final promotions = rawPromotions is List
        ? rawPromotions.map((e) => ProductPromotionDto.parse(e)).toList()
        : <ProductPromotionDto>[];

    return ProductDto(
      id: data['id'],
      posId: data['posId'],
      title: data['title'],
      description: data['description'],
      image: data['image'],
      compound: List.from(data['compound']),
      price: data['price'],
      type: ProductType.values.byName(data['type']),
      available: available,
      promotions: promotions,
    );
  }

  ProductEntity toEntity() => ProductEntity(
    id: id,
    posId: posId,
    title: title,
    description: description,
    imageUrl: '$baseCdnUrl/product/$image',
    compound: compound,
    price: price,
    type: type,
    available: available,
    promotions: promotions.map((p) => p.toEntity()).toList(),
  );
}
