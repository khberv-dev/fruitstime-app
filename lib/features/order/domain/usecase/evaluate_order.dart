import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/data/repository/order_repository.dart';
import 'package:fruitstime/features/order/domain/entity/order_evaluation_entity.dart';
import 'package:fruitstime/features/product/domain/entity/product_entity.dart';

final evaluateOrderProvider = Provider((ref) => EvaluateOrder(ref.read(orderRepositoryProvider)));

class EvaluateOrder {
  final OrderRepository _repository;

  EvaluateOrder(this._repository);

  Future<OrderEvaluationEntity> call(
    Map<ProductEntity, int> cart, {
    required String branchId,
    required OrderType type,
    String? addressId,
  }) async {
    final items = cart.entries.map((e) => {'productId': e.key.id, 'quantity': e.value}).toList();

    final dto = await _repository.evaluate(
      items,
      branchId: branchId,
      type: type,
      addressId: addressId,
    );

    return dto.toEntity();
  }
}
