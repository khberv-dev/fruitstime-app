import 'package:fruitstime/features/product/data/enum/product_type.dart';

class ProductEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> compound;
  final int price;
  final ProductType type;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.compound,
    required this.price,
    required this.type,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
