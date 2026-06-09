import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/data/repository/order_repository.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';

final getActiveOrderProvider = Provider((ref) => GetActiveOrder(ref.read(orderRepositoryProvider)));

class GetActiveOrder {
  final OrderRepository _repository;

  GetActiveOrder(this._repository);

  Future<OrderEntity?> call() async {
    final dto = await _repository.getActive();
    return dto?.toEntity();
  }
}
