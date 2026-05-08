import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/domain/entity/order_entity.dart';

final selectedOrderProvider = NotifierProvider<_SelectedOrderNotifier, OrderEntity?>(
  _SelectedOrderNotifier.new,
);

class _SelectedOrderNotifier extends Notifier<OrderEntity?> {
  @override
  OrderEntity? build() => null;

  void select(OrderEntity? order) {
    state = order;
  }
}
