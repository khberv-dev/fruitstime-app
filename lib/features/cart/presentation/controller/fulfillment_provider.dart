import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/features/order/data/enum/order_type.dart';
import 'package:fruitstime/features/order/domain/entity/order_address_entity.dart';

class FulfillmentState {
  final OrderType type;
  final OrderAddressEntity? address;

  const FulfillmentState({this.type = OrderType.pickup, this.address});

  FulfillmentState copyWith({OrderType? type, OrderAddressEntity? address}) =>
      FulfillmentState(type: type ?? this.type, address: address ?? this.address);
}

final fulfillmentProvider = NotifierProvider<_FulfillmentNotifier, FulfillmentState>(
  _FulfillmentNotifier.new,
);

class _FulfillmentNotifier extends Notifier<FulfillmentState> {
  @override
  FulfillmentState build() => const FulfillmentState();

  void setType(OrderType type) => state = state.copyWith(type: type);

  void setAddress(OrderAddressEntity address) => state = state.copyWith(address: address);
}
