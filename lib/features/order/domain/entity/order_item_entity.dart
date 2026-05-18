import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

class OrderItemEntity {
  final String id;
  final int quantity;
  final int price;
  final int actualPrice;
  final ProductEntity product;

  OrderItemEntity({
    required this.id,
    required this.quantity,
    required this.price,
    required this.actualPrice,
    required this.product,
  });
}
