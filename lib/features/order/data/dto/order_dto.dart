import 'package:fruitstime/features/order/data/enum/order_status.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/order/domain/entity/order_item_entity.dart';
import 'package:fruitstime/features/product/data/dto/product_dto.dart';
import 'package:jiffy/jiffy.dart';

class OrderItemDto {
  final String id;
  final int quantity;
  final int price;
  final int actualPrice;
  final ProductDto product;

  OrderItemDto({
    required this.id,
    required this.quantity,
    required this.price,
    required this.actualPrice,
    required this.product,
  });

  factory OrderItemDto.parse(Map<String, dynamic> data) {
    final product = ProductDto.parse(data['product']);
    final quantity = data['quantity'] ?? 1;
    final fallback = product.price * (quantity as int);
    return OrderItemDto(
      id: data['id'],
      quantity: quantity,
      price: data['price'] ?? fallback,
      actualPrice: data['actualPrice'] ?? fallback,
      product: product,
    );
  }

  OrderItemEntity toEntity() => OrderItemEntity(
    id: id,
    quantity: quantity,
    price: price,
    actualPrice: actualPrice,
    product: product.toEntity(),
  );
}

class OrderDto {
  final String id;
  final int? posId;
  final OrderStatus status;
  final OrderType type;
  final OrderAddressEntity? address;
  final String? link;
  final List<OrderItemDto> items;
  final Jiffy createdAt;
  final Jiffy updatedAt;

  OrderDto({
    required this.id,
    this.posId,
    required this.status,
    required this.type,
    this.address,
    this.link,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDto.parse(Map<String, dynamic> data) {
    final addressData = data['address'];
    return OrderDto(
      id: data['id'],
      posId: data['posId'],
      status: OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => OrderStatus.created,
      ),
      type: OrderType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => OrderType.pickup,
      ),
      address: addressData != null
          ? OrderAddressEntity(
              lat: (addressData['lat'] as num).toDouble(),
              long: (addressData['long'] as num).toDouble(),
            )
          : null,
      link: data['link'] as String?,
      items: (data['items'] as List<dynamic>? ?? []).map((e) => OrderItemDto.parse(e)).toList(),
      createdAt: Jiffy.parse(data['createdAt']),
      updatedAt: Jiffy.parse(data['updatedAt']),
    );
  }

  OrderEntity toEntity() => OrderEntity(
    id: id,
    posId: posId,
    status: status,
    type: type,
    address: address,
    link: link,
    items: items.map((e) => e.toEntity()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
