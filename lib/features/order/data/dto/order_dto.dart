import 'package:fruitstime/features/order/data/enum/order_status.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/domain/entity/order_item_entity.dart';
import 'package:fruitstime/features/product/data/dto/product_dto.dart';
import 'package:jiffy/jiffy.dart';

class OrderItemDto {
  final String id;
  final int quantity;
  final ProductDto product;

  OrderItemDto({required this.id, required this.quantity, required this.product});

  factory OrderItemDto.parse(Map<String, dynamic> data) => OrderItemDto(
    id: data['id'],
    quantity: data['quantity'] ?? 1,
    product: ProductDto.parse(data['product']),
  );

  OrderItemEntity toEntity() =>
      OrderItemEntity(id: id, quantity: quantity, product: product.toEntity());
}

class OrderDto {
  final String id;
  final int number;
  final OrderStatus status;
  final List<OrderItemDto> items;
  final Jiffy createdAt;
  final Jiffy updatedAt;

  OrderDto({
    required this.id,
    required this.number,
    required this.status,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDto.parse(Map<String, dynamic> data) => OrderDto(
    id: data['id'],
    number: data['orderId'],
    status: OrderStatus.values.firstWhere(
      (s) => s.name == data['status'],
      orElse: () => OrderStatus.created,
    ),
    items: (data['items'] as List<dynamic>? ?? []).map((e) => OrderItemDto.parse(e)).toList(),
    createdAt: Jiffy.parse(data['createdAt']),
    updatedAt: Jiffy.parse(data['updatedAt']),
  );

  OrderEntity toEntity() => OrderEntity(
    id: id,
    number: number,
    status: status,
    items: items.map((e) => e.toEntity()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
