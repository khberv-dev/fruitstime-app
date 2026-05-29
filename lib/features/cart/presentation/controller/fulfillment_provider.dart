import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';

/// Tracks the chosen fulfillment method (pickup vs delivery). The delivery
/// address itself lives in selectedAddressProvider.
final fulfillmentProvider = NotifierProvider<_FulfillmentNotifier, OrderType>(
  _FulfillmentNotifier.new,
);

class _FulfillmentNotifier extends Notifier<OrderType> {
  @override
  OrderType build() => OrderType.pickup;

  void setType(OrderType type) => state = type;
}
