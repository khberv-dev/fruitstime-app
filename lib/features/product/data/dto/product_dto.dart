import 'package:fruitstime/core/data/network/config.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class ProductDto {
  final String id;
  final String title;
  final String description;
  final String image;
  final List<String> compound;
  final int price;

  ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.compound,
    required this.price,
  });

  factory ProductDto.parse(Map<String, dynamic> data) => ProductDto(
    id: data['id'],
    title: data['title'],
    description: data['description'],
    image: data['image'],
    compound: List.from(data['compound']),
    price: data['price'],
  );

  ProductEntity toEntity() => ProductEntity(
    id: id,
    title: title,
    description: description,
    imageUrl: '$baseCdnUrl/product/$image',
    compound: compound,
    price: price,
  );
}
