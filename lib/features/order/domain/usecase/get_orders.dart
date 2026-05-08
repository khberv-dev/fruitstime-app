import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/data/repository/order_repository.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';

final getOrdersProvider = Provider((ref) => GetOrders(ref.read(orderRepositoryProvider)));

class GetOrders {
  final OrderRepository _repository;

  GetOrders(this._repository);

  Future<List<OrderEntity>> call() async {
    final data = await _repository.getMine();

    return data.map((e) => e.toEntity()).toList();
  }
}
