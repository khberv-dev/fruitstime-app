import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/data/repository/order_repository.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

final createOrderProvider = Provider((ref) => CreateOrder(ref.read(orderRepositoryProvider)));

class CreateOrder {
  final OrderRepository _repository;

  CreateOrder(this._repository);

  Future<OrderEntity> call(
    Map<ProductEntity, int> cart, {
    required String branchId,
    required OrderType type,
    OrderAddressEntity? address,
  }) async {
    final items = cart.entries.map((e) => {'productId': e.key.id, 'quantity': e.value}).toList();

    final dto = await _repository.create(items, branchId: branchId, type: type, address: address);

    return dto.toEntity();
  }
}
