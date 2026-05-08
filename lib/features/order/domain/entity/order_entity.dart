import 'package:fruitstime/features/order/data/enum/order_status.dart';
import 'package:fruitstime/features/order/domain/entity/order_item_entity.dart';
import 'package:jiffy/jiffy.dart';

class OrderEntity {
  final String id;
  final int number;
  final OrderStatus status;
  final List<OrderItemEntity> items;
  final Jiffy createdAt;
  final Jiffy updatedAt;

  OrderEntity({
    required this.id,
    required this.number,
    required this.status,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  String get itemsSummary => items.map((e) => e.product.title).join(', ');

  int get itemsCount => items.fold<int>(0, (sum, e) => sum + e.quantity);

  int get totalPrice => items.fold<int>(0, (sum, e) => sum + e.product.price * e.quantity);
}
