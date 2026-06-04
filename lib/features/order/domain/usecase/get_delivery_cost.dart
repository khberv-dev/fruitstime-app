import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/data/repository/order_repository.dart';

final getDeliveryCostProvider = Provider(
  (ref) => GetDeliveryCost(ref.read(orderRepositoryProvider)),
);

class GetDeliveryCost {
  final OrderRepository _repository;

  GetDeliveryCost(this._repository);

  Future<int> call({required String branchId, required String addressId}) =>
      _repository.getDeliveryCost(branchId: branchId, addressId: addressId);
}
