import 'package:fruitstime/core/data/network/config.dart';
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

  ProductDto({
    required this.id,
    this.posId,
    required this.title,
    required this.description,
    required this.image,
    required this.compound,
    required this.price,
    required this.type,
  });

  factory ProductDto.parse(Map<String, dynamic> data) => ProductDto(
    id: data['id'],
    posId: data['posId'],
    title: data['title'],
    description: data['description'],
    image: data['image'],
    compound: List.from(data['compound']),
    price: data['price'],
    type: ProductType.values.byName(data['type']),
  );

  ProductEntity toEntity() => ProductEntity(
    id: id,
    posId: posId,
    title: title,
    description: description,
    imageUrl: '$baseCdnUrl/product/$image',
    compound: compound,
    price: price,
    type: type,
  );
}
