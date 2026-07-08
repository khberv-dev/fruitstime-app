import 'package:fruitstime/features/product/domain/entity/product_promotion_entity.dart';

class ProductPromotionDto {
  final String type;
  final String name;

  const ProductPromotionDto({required this.type, required this.name});

  factory ProductPromotionDto.parse(Map<String, dynamic> data) =>
      ProductPromotionDto(type: data['type'], name: data['name']);

  ProductPromotionEntity toEntity() => ProductPromotionEntity(type: type, name: name);
}
